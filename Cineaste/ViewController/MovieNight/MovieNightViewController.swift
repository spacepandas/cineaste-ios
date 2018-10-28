//
//  MovieNightViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 07.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class MovieNightViewController: UITableViewController {
    @IBOutlet private weak var searchForFriendsView: UIView!
    @IBOutlet private weak var searchFriendsLabel: UILabel!

    @IBOutlet private weak var permissionDeniedView: UIView!
    @IBOutlet private weak var nearbyIcon: UIImageView!
    @IBOutlet private weak var permissionButton: UIButton!
    @IBOutlet private weak var permissionDeniedDescription: UILabel!

    @IBOutlet private weak var footerView: UIView!
    @IBOutlet private weak var usageDescription: UILabel!
    @IBOutlet private weak var microphoneIcon: UIImageView!
    @IBOutlet private weak var bluetoothIcon: UIImageView!

    private var canUseNearby: Bool = true {
        didSet {
            updateTableView(with: canUseNearby)
        }
    }

    private var canUseBluetooth: Bool = true {
        didSet {
            bluetoothIcon.tintColor = canUseBluetooth ? .accentTextOnBlack : .accentTextOnWhite
        }
    }

    private var canUseMicrophone: Bool = true {
        didSet {
            microphoneIcon.tintColor = canUseMicrophone ? .accentTextOnBlack : .accentTextOnWhite
        }
    }

    private var microphonePermissionErrorHandler: ((Bool) -> Void)?
    private var bluetoothPowerErrorHandler: ((Bool) -> Void)?
    private var nearbyPermissionHandler: ((Bool) -> Void)?

    lazy var gnsMessageManager: GNSMessageManager =
        GNSMessageManager(apiKey: ApiKeyStore.nearbyKey) { (params: GNSMessageManagerParams?) in
            guard let params = params else { return }
            //Tracking user settings that affect Nearby
            params.microphonePermissionErrorHandler = self.microphonePermissionErrorHandler ?? { _ in }
            params.bluetoothPowerErrorHandler = self.bluetoothPowerErrorHandler  ?? { _ in }
        }

    lazy var ownNearbyMessage = { generateOwnNearbyMessage() }()

    var storageManager: MovieStorage?

    var currentPermission: GNSPermission?
    var currentPublication: GNSPublication?
    var currentSubscription: GNSSubscription?

    var nearbyMessages = [NearbyMessage]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.backgroundView?.isHidden = !self.nearbyMessages.isEmpty
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = String.movieNightTitle

        canUseNearby = GNSPermission.isGranted()
        canUseBluetooth = true
        canUseMicrophone = true

        configureViews()
        localizeContent()

        configureDebugModeHelper()
        configureTableView()
        configureStateObserver()
    }

    func configure(with storageManager: MovieStorage) {
        self.storageManager = storageManager
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        currentPermission = GNSPermission(changedHandler: nearbyPermissionHandler)
        publishWatchlistMovies()
        subscribeToNearbyMessages()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        currentPermission = nil
        currentPublication = nil
        currentSubscription = nil
    }

    // MARK: - Actions

    @IBAction func cancelMovieNight(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func allowNearby(_ sender: UIButton) {
        GNSPermission.setGranted(true)
    }

    @objc
    func toggleSearchingForFriendsMode() {
        #if DEBUG
        if nearbyMessages.isEmpty {
            let simulatorMovies = [
                NearbyMovie(id: 1, title: "Film B", posterPath: nil),
                NearbyMovie(id: 2, title: "Asterix", posterPath: nil),
                NearbyMovie(id: 3, title: "Film 3", posterPath: nil)
            ]
            let developerMovies = [
                NearbyMovie(id: 1, title: "Film B", posterPath: nil),
                NearbyMovie(id: 2, title: "Asterix", posterPath: nil)
            ]

            nearbyMessages = [
                NearbyMessage(userName: "Simulator", deviceId: "1", movies: simulatorMovies),
                NearbyMessage(userName: "Developer", deviceId: "2", movies: developerMovies)
            ]
        } else {
            nearbyMessages = []
        }
        #endif
    }

    // MARK: - Configuration

    private func configureDebugModeHelper() {
        #if DEBUG
        let tripleTapGestureRecognizer =
            UITapGestureRecognizer(target: self,
                                   action: #selector(toggleSearchingForFriendsMode))
        tripleTapGestureRecognizer.numberOfTapsRequired = 3
        view.addGestureRecognizer(tripleTapGestureRecognizer)
        #endif
    }

    private func localizeContent() {
        searchFriendsLabel.text = .searchFriendsOnMovieNight

        //TODO: localize labels / button
        permissionButton.setTitle("Nearby erlauben", for: .normal)
        permissionDeniedDescription.text = "Ohne Google Nearby kann nicht nach Geräten in deiner Nähe gesucht werden"
        usageDescription.text = "Google Nearby benutzt gerade folgende Technologien, um Freunde in der Nähe zu finden"
    }

    private func configureViews() {
        searchFriendsLabel.textColor = .accentTextOnBlack
        nearbyIcon.tintColor = .accentTextOnBlack
        permissionDeniedDescription.textColor = .accentTextOnBlack
        usageDescription.textColor = .accentTextOnBlack
    }

    private func configureTableView() {
        tableView.backgroundColor = UIColor.basicBackground

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80

        tableView.alwaysBounceVertical = false
    }

    private func configureStateObserver() {
        bluetoothPowerErrorHandler = { hasError in
            self.canUseBluetooth = !hasError
        }

        microphonePermissionErrorHandler = { hasError in
            self.canUseMicrophone = !hasError
        }

        nearbyPermissionHandler = { granted in
            if self.canUseNearby != granted {
                self.canUseNearby = granted
            }
        }
    }

    private func updateTableView(with canUseNearby: Bool) {
        if canUseNearby {
            tableView.tableFooterView = footerView
            tableView.backgroundView = searchForFriendsView
            tableView.backgroundView?.isHidden = !self.nearbyMessages.isEmpty
        } else {
            tableView.tableFooterView = UIView()
            tableView.backgroundView = permissionDeniedView
        }
    }

    private func generateOwnNearbyMessage() -> NearbyMessage {
        guard let storageManager = storageManager,
            let username = UserDefaultsManager.getUsername()
            else { fatalError("ViewController should never be presented without a username") }

        let nearbyMovies = storageManager
            .fetchAllWatchlistMovies()
            .compactMap { storedMovie -> NearbyMovie in
                NearbyMovie(id: storedMovie.id,
                            title: storedMovie.title ?? .unknownTitle,
                            posterPath: storedMovie.posterPath)
            }

        return NearbyMessage(with: username, movies: nearbyMovies)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch Segue(initWith: segue) {
        case .showMovieMatches?:
            guard
                let (title, nearbyMessages) = sender as? (String, [NearbyMessage]),
                let storageManager = storageManager
                else { return }

            let vc = segue.destination as? MovieMatchViewController
            vc?.configure(with: title,
                          messagesToMatch: nearbyMessages,
                          storageManager: storageManager)
        default:
            return
        }
    }
}

extension MovieNightViewController: Instantiable {
    static var storyboard: Storyboard { return .movieNight }
    static var storyboardID: String? { return "MovieNightViewController" }
}
