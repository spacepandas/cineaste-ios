//
//  MovieNightViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 07.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class MovieNightViewController: UITableViewController {
    enum NearbyPermissionState: Equatable {
        case nearbyPermissionPending
        case denied(_ permissions: [Permission])
        case canUseNearby
    }

    enum Permission: String {
        case microphone
        case bluetooth
        case nearby
    }

    @IBOutlet private weak var searchForFriendsView: UIView!
    @IBOutlet private weak var searchFriendsLabel: UILabel! {
        didSet {
            searchFriendsLabel.text = .searchFriendsOnMovieNight
            searchFriendsLabel.textColor = .accentTextOnBlack
        }
    }
    @IBOutlet private weak var permissionDeniedView: UIView!
    @IBOutlet private weak var permissionDeniedDescription: UILabel! {
        didSet {
            permissionDeniedDescription.textColor = .accentTextOnBlack
        }
    }

    private var state: NearbyPermissionState = .nearbyPermissionPending {
        didSet {
            switch state {
            //TODO: handle states localized
            case .nearbyPermissionPending:
                tableView.backgroundView = permissionDeniedView
                permissionDeniedDescription.text = "Nearby Permission Pending"
            case .denied(let permissions):
                tableView.backgroundView = permissionDeniedView
                permissionDeniedDescription.text = "\(permissions.map { $0.rawValue }.joined(separator: ", ")) denied"
            case .canUseNearby:
                tableView.backgroundView = searchForFriendsView
                tableView.backgroundView?.isHidden = !self.nearbyMessages.isEmpty
            }
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
        state = GNSPermission.isGranted() ? .canUseNearby : .nearbyPermissionPending

        #if DEBUG
        let tripleTapGestureRecognizer =
            UITapGestureRecognizer(target: self,
                                   action: #selector(toggleSearchingForFriendsMode))
        tripleTapGestureRecognizer.numberOfTapsRequired = 3
        view.addGestureRecognizer(tripleTapGestureRecognizer)
        #endif

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

        currentPublication = nil
        currentSubscription = nil
        currentPermission = nil
    }

    // MARK: - Actions

    @IBAction func cancelMovieNight(_ sender: Any) {
        dismiss(animated: true)
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

    private func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.basicBackground

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80

        tableView.alwaysBounceVertical = false
    }

    private func configureStateObserver() {
        bluetoothPowerErrorHandler = { hasError in
            self.state = self.updateState(with: .bluetooth, hasError: hasError)
        }

        microphonePermissionErrorHandler = { hasError in
            self.state = self.updateState(with: .microphone, hasError: hasError)
        }

        nearbyPermissionHandler = { granted in
            self.state = self.updateState(with: .nearby, hasError: !granted)
        }
    }

    private func updateState(with permission: Permission, hasError: Bool) -> NearbyPermissionState {
        var state = self.state
        switch state {
        case .nearbyPermissionPending:
            if hasError {
                state = .denied([permission])
            } else {
                state = .canUseNearby
            }
        case .denied(var permissions):
            if hasError {
                if !permissions.contains(permission) {
                    permissions.append(permission)
                    state = .denied(permissions)
                }
            } else {
                let newPermissions = permissions.filter { $0 != permission }
                if newPermissions.isEmpty {
                    state = .canUseNearby
                } else {
                    state = .denied(newPermissions)
                }
            }
        case .canUseNearby:
            if hasError {
                state = .denied([permission])
            }
        }
        return state
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

    private func publishWatchlistMovies() {
        guard let storageManager = storageManager,
            let username = UserDefaultsManager.username
            else { return }

        let nearbyMovies = storageManager
            .fetchAllWatchlistMovies()
            .compactMap { storedMovie -> NearbyMovie? in
                guard let title = storedMovie.title else { return nil }
                return NearbyMovie(id: storedMovie.id,
                                   title: title,
                                   posterPath: storedMovie.posterPath)
            }

        let nearbyMessage = NearbyMessage(with: username, movies: nearbyMovies)
        ownNearbyMessage = nearbyMessage

        guard let messageData = try? JSONEncoder().encode(nearbyMessage)
            else { return }

        currentPublication = gnsMessageManager.publication(
            with: GNSMessage(content: messageData)
        )
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
