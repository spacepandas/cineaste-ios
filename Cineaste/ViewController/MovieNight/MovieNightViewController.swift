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
    @IBOutlet private weak var searchFriendsLabel: UILabel! {
        didSet {
            searchFriendsLabel.text = .searchFriendsOnMovieNight
            searchFriendsLabel.textColor = .accentTextOnBlack
        }
    }
    @IBOutlet private weak var permissionDeniedView: UIView!
    @IBOutlet private weak var nearbyIcon: UIImageView! {
        didSet {
            nearbyIcon.tintColor = .accentTextOnBlack
        }
    }
    @IBOutlet private weak var permissionButton: UIButton! {
        didSet {
            //TODO: localize
            permissionButton.setTitle("Nearby erlauben", for: .normal)
        }
    }
    @IBOutlet private weak var permissionDeniedDescription: UILabel! {
        didSet {
            //TODO: localize
            permissionDeniedDescription.text = "Ohne Google Nearby kann nicht nach Geräten in deiner Nähe gesucht werden"
            permissionDeniedDescription.textColor = .accentTextOnBlack
        }
    }
    @IBOutlet private weak var usageDescription: UILabel! {
        didSet {
            //TODO: localize
            usageDescription.text = "Google Nearby benutzt gerade folgende Technologien, um Freunde in der Nähe zu finden"
            usageDescription.textColor = .accentTextOnBlack
        }
    }
    @IBOutlet private weak var microphoneIcon: UIImageView!
    @IBOutlet private weak var bluetoothIcon: UIImageView!
    @IBOutlet private weak var footerView: UIView!

    private var canUseNearby: Bool = true {
        didSet {
            if canUseNearby {
                tableView.tableFooterView = footerView
                tableView.backgroundView = searchForFriendsView
                tableView.backgroundView?.isHidden = !self.nearbyMessages.isEmpty
            } else {
                tableView.tableFooterView = UIView()
                tableView.backgroundView = permissionDeniedView
            }
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

    private lazy var gnsMessageManager: GNSMessageManager =
        GNSMessageManager(apiKey: ApiKeyStore.nearbyKey) { (params: GNSMessageManagerParams?) in
            guard let params = params else { return }
            //Tracking user settings that affect Nearby
            params.microphonePermissionErrorHandler = self.microphonePermissionErrorHandler ?? { _ in }
            params.bluetoothPowerErrorHandler = self.bluetoothPowerErrorHandler  ?? { _ in }
        }

    private var storageManager: MovieStorage?

    private var microphonePermissionErrorHandler: ((Bool) -> Void)?
    private var bluetoothPowerErrorHandler: ((Bool) -> Void)?
    private var nearbyPermissionHandler: ((Bool) -> Void)?

    private var currentPermission: GNSPermission?
    private var currentPublication: GNSPublication?
    private var currentSubscription: GNSSubscription?

    private var ownNearbyMessage: NearbyMessage?
    private var nearbyMessages = [NearbyMessage]() {
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

        ownNearbyMessage = generateOwnNearbyMessage()

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
            let simulatorMovies = [NearbyMovie(id: 1,
                                               title: "Film B",
                                               posterPath: nil),
                                   NearbyMovie(id: 2,
                                               title: "Asterix",
                                               posterPath: nil),
                                   NearbyMovie(id: 3,
                                               title: "Film 3",
                                               posterPath: nil)]
            let developerMovies = [NearbyMovie(id: 1,
                                               title: "Film B",
                                               posterPath: nil),
                                   NearbyMovie(id: 2,
                                               title: "Asterix",
                                               posterPath: nil)]

            nearbyMessages = [NearbyMessage(userName: "Simulator",
                                            deviceId: "1",
                                            movies: simulatorMovies),
                              NearbyMessage(userName: "Developer",
                                            deviceId: "2",
                                            movies: developerMovies)]
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

    // MARK: - Nearby

    private func generateOwnNearbyMessage() -> NearbyMessage? {
        guard let storageManager = storageManager,
            let username = UserDefaultsManager.getUsername()
            else { return nil }

        let nearbyMovies = storageManager
            .fetchAllWatchlistMovies()
            .compactMap { storedMovie -> NearbyMovie? in
                guard let title = storedMovie.title else { return nil }
                return NearbyMovie(id: storedMovie.id,
                                   title: title,
                                   posterPath: storedMovie.posterPath)
            }

        return NearbyMessage(with: username, movies: nearbyMovies)
    }

    private func publishWatchlistMovies() {
        if ownNearbyMessage == nil {
            ownNearbyMessage = generateOwnNearbyMessage()
        }

        if let nearbyMessage = ownNearbyMessage,
            let messageData = try? JSONEncoder().encode(nearbyMessage) {

            currentPublication = gnsMessageManager.publication(
                with: GNSMessage(content: messageData)
            )
        }
    }

    private func subscribeToNearbyMessages() {
        currentSubscription = gnsMessageManager.subscription(
            messageFoundHandler: { message in
                guard let nearbyMessage = self.convertGNSMessage(from: message)
                    else { return }

                // add nearbyMessage
                if !self.nearbyMessages.contains(nearbyMessage) {
                    self.nearbyMessages.append(nearbyMessage)
                }
            },
            messageLostHandler: { message in
                guard let nearbyMessage = self.convertGNSMessage(from: message)
                    else { return }

                // remove nearbyMessage
                self.nearbyMessages = self.nearbyMessages
                    .filter { $0 != nearbyMessage }
            }
        )
    }

    private func convertGNSMessage(from message: GNSMessage?) -> NearbyMessage? {
        if let data = message?.content,
            let nearbyMessage = try? JSONDecoder().decode(NearbyMessage.self,
                                                          from: data) {
            return nearbyMessage
        } else {
            return nil
        }
    }

    // MARK: - TableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyMessages.isEmpty ? 0 : nearbyMessages.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieNightUserCell = tableView.dequeueCell(identifier: MovieNightUserCell.identifier)

        if indexPath.row == 0 {
            //all lists together

            guard let ownMessage = ownNearbyMessage else { return cell }
            var combinedMessages = nearbyMessages
            combinedMessages.append(ownMessage)

            let numberOfAllMovies = combinedMessages
                .compactMap { $0.movies.count }
                .reduce(0, +)
            let names = combinedMessages.map { $0.userName }
            cell.configureAll(numberOfMovies: numberOfAllMovies,
                              namesOfFriends: names)
        } else {
            let message = nearbyMessages[indexPath.row - 1]
            cell.configure(userName: message.userName,
                           numberOfMovies: message.movies.count)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            guard let ownMessage = ownNearbyMessage else { return }
            var combinedMessages = nearbyMessages
            combinedMessages.append(ownMessage)

            performSegue(withIdentifier: Segue.showMovieMatches.rawValue,
                         sender: ("all", combinedMessages))
        } else {
            let nearbyMessage = nearbyMessages[indexPath.row - 1]
            performSegue(withIdentifier: Segue.showMovieMatches.rawValue,
                         sender: (nearbyMessage.userName, [nearbyMessage]))
        }
    }
}

extension MovieNightViewController: Instantiable {
    static var storyboard: Storyboard { return .movieNight }
    static var storyboardID: String? { return "MovieNightViewController" }
}
