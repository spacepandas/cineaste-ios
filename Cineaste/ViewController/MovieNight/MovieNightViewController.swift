//
//  MovieNightViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 07.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class MovieNightViewController: UIViewController {
    @IBOutlet fileprivate weak var usersTableView: UITableView! {
        didSet {
            usersTableView.dataSource = self
            usersTableView.backgroundColor = UIColor.basicBackground

            usersTableView.allowsSelection = false

            usersTableView.estimatedRowHeight = 100
            usersTableView.rowHeight = UITableView.automaticDimension

            usersTableView.tableFooterView = UIView()
            usersTableView.backgroundView = searchForFriendsView
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
                self.usersTableView.backgroundView?.isHidden = !self.nearbyMessages.isEmpty

                self.usersTableView.reloadData()
            }
        }
    }

    fileprivate var myNearbyMessage: NearbyMessage?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = String.movieNightTitle
        startButton.isEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if UserDefaultsManager.getUsername() != nil {
            startPublishing()
            startSubscribing()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        currentPublication = nil
        currentSubscription = nil
    }

    // MARK: - Actions

    @IBAction func cancelButtonTouched(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func startMovieNightButtonTouched(_ sender: UIButton) {
        guard let myNearbyMessage = myNearbyMessage else {
            return
        }

        var clone = [NearbyMessage](nearbyMessages)
        clone.append(myNearbyMessage)
        performSegue(withIdentifier: Segue.showMovieMatches.rawValue,
                     sender: clone)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch Segue(initWith: segue) {
        case .showMovieMatches?:
            guard let nearbyMessages = sender as? [NearbyMessage] else {
                return
            }

            let vc = segue.destination as? MovieMatchViewController
            vc?.configure(with: nearbyMessages)
            vc?.storageManager = storageManager
        default:
            return
        }
    }

    // MARK: - Nearby

    fileprivate func startPublishing() {
        guard let storageManager = storageManager else { return }
        let nearbyMovies = storageManager
            .fetchAllWantToSeeMovies()
            .compactMap { storedMovie -> NearbyMovie? in
                guard let title = storedMovie.title else { return nil }
                return NearbyMovie(id: storedMovie.id,
                                   title: title,
                                   posterPath: storedMovie.posterPath)
            }

        guard let username = UserDefaultsManager.getUsername() else { return }
        let nearbyMessage = NearbyMessage.create(withUsername: username,
                                                 movies: nearbyMovies)
        myNearbyMessage = nearbyMessage

        guard let messageData = try? JSONEncoder().encode(nearbyMessage)
            else { return }
        currentPublication = gnsMessageManager
            .publication(with: GNSMessage(content: messageData))
    }

    fileprivate func startSubscribing() {
        currentSubscription = gnsMessageManager.subscription(
            messageFoundHandler: { message in
                guard let data = message?.content,
                    let nearbyMessage = try? JSONDecoder().decode(NearbyMessage.self,
                                                                  from: data)
                    else { return }

                guard self.nearbyMessages.index(of: nearbyMessage) == nil
                    else { return }

                DispatchQueue.main.async {
                    self.nearbyMessages.append(nearbyMessage)
                }
            }, messageLostHandler: { message in
            guard let data = message?.content,
                let nearbyMessage = try? JSONDecoder().decode(NearbyMessage.self,
                                                              from: data)
                else { return }

            self.nearbyMessages = self.nearbyMessages.filter { $0 != nearbyMessage }
            })
    }
}

extension MovieNightViewController: Instantiable {
    static var storyboard: Storyboard { return .movieNight }
    static var storyboardID: String? { return "MovieNightViewController" }
}
