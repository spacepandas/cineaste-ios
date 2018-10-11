//
//  MovieNightViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 07.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class MovieNightViewController: UIViewController {
    @IBOutlet fileprivate weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.backgroundColor = UIColor.basicBackground

            tableView.allowsSelection = false

            tableView.estimatedRowHeight = 100
            tableView.rowHeight = UITableView.automaticDimension

            tableView.tableFooterView = UIView()
            tableView.backgroundView = searchForFriendsView
        }
    }

    @IBOutlet fileprivate weak var startButton: StartMovieNightButton!

    @IBOutlet fileprivate weak var searchForFriendsView: UIView!
    @IBOutlet fileprivate weak var searchFriendsLabel: UILabel! {
        didSet {
            searchFriendsLabel.text = .searchFriendsOnMovieNight
            searchFriendsLabel.textColor = .accentTextOnBlack
        }
    }

    var storageManager: MovieStorage?

    fileprivate lazy var gnsMessageManager: GNSMessageManager =
        GNSMessageManager(apiKey: ApiKeyStore.nearbyKey)
    fileprivate var currentPublication: GNSPublication?
    fileprivate var currentSubscription: GNSSubscription?

    var nearbyMessages = [NearbyMessage]() {
        didSet {
            DispatchQueue.main.async {
                self.startButton.isEnabled = !self.nearbyMessages.isEmpty
                self.tableView.backgroundView?.isHidden = !self.nearbyMessages.isEmpty

                self.tableView.reloadData()
            }
        }
    }

    fileprivate var ownNearbyMessage: NearbyMessage?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = String.movieNightTitle
        startButton.isEnabled = false

        #if DEBUG
        let tripleTapGestureRecognizer =
            UITapGestureRecognizer(target: self,
                                   action: #selector(toggleSearchingForFriendsMode))
        tripleTapGestureRecognizer.numberOfTapsRequired = 3
        view.addGestureRecognizer(tripleTapGestureRecognizer)
        #endif
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

    @IBAction func startMovieNightButtonTouched(_ sender: UIButton) {
        performSegue(withIdentifier: Segue.showMovieMatches.rawValue,
                     sender: nearbyMessages)
    }

    @objc
    func toggleSearchingForFriendsMode() {
        #if DEBUG
        if nearbyMessages.isEmpty {
            let nearbyMovies = [NearbyMovie(id: 1,
                                            title: "Film 1",
                                            posterPath: nil),
                                NearbyMovie(id: 2,
                                            title: "Film 2",
                                            posterPath: nil),
                                NearbyMovie(id: 3,
                                            title: "Film 3",
                                            posterPath: nil)]

            nearbyMessages = [NearbyMessage(userName: "Simulator",
                                            deviceId: "1",
                                            movies: nearbyMovies)]
        } else {
            nearbyMessages = []
        }
        #endif
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch Segue(initWith: segue) {
        case .showMovieMatches?:
            guard
                let nearbyMessages = sender as? [NearbyMessage],
                let ownMessage = ownNearbyMessage
                else { return }

            var combinedMessages = nearbyMessages
            combinedMessages.append(ownMessage)

            let vc = segue.destination as? MovieMatchViewController
            vc?.configure(with: combinedMessages)
            vc?.storageManager = storageManager
        default:
            return
        }
    }

    // MARK: - Nearby

    fileprivate func publishWatchlistMovies() {
        guard let storageManager = storageManager else { return }

        let nearbyMovies = storageManager
            .fetchAllWatchlistMovies()
            .compactMap { storedMovie -> NearbyMovie? in
                guard let title = storedMovie.title else { return nil }
                return NearbyMovie(id: storedMovie.id,
                                   title: title,
                                   posterPath: storedMovie.posterPath)
            }

        guard let username = UserDefaultsManager.getUsername() else { return }

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
}

extension MovieNightViewController: Instantiable {
    static var storyboard: Storyboard { return .movieNight }
    static var storyboardID: String? { return "MovieNightViewController" }
}
