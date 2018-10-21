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

    private var storageManager: MovieStorage?

    private lazy var gnsMessageManager: GNSMessageManager =
        GNSMessageManager(apiKey: ApiKeyStore.nearbyKey)
    private var currentPublication: GNSPublication?
    private var currentSubscription: GNSSubscription?

    private var nearbyMessages = [NearbyMessage]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.backgroundView?.isHidden = !self.nearbyMessages.isEmpty

                self.tableView.reloadData()
            }
        }
    }

    private var ownNearbyMessage: NearbyMessage?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = String.movieNightTitle

        #if DEBUG
        let tripleTapGestureRecognizer =
            UITapGestureRecognizer(target: self,
                                   action: #selector(toggleSearchingForFriendsMode))
        tripleTapGestureRecognizer.numberOfTapsRequired = 3
        view.addGestureRecognizer(tripleTapGestureRecognizer)
        #endif

        configureTableView()
    }

    func configure(with storageManager: MovieStorage) {
        self.storageManager = storageManager
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        publishWatchlistMovies()
        subscribeToNearbyMessages()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        currentPublication = nil
        currentSubscription = nil
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

        tableView.backgroundView = searchForFriendsView

        tableView.alwaysBounceVertical = false
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

    fileprivate func publishWatchlistMovies() {
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

    fileprivate func subscribeToNearbyMessages() {
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
