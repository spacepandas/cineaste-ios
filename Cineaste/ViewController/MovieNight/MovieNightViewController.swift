//
//  MovieNightViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 07.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class MovieNightViewController: UIViewController {
    @IBOutlet fileprivate weak var usersTableView: UITableView!
    @IBOutlet fileprivate weak var startButton: UIButton!

    fileprivate var currentPublication: GNSPublication?
    fileprivate var currentSubscription: GNSSubscription?

    fileprivate var nearbyMessages = [NearbyMessage]()
    fileprivate var myNearbyMessage: NearbyMessage?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Movie-Night", comment: "Title for movie night viewController")
        view.backgroundColor = UIColor.basicBackground
        usersTableView.dataSource = self
        usersTableView.backgroundColor = UIColor.basicBackground
        usersTableView.tableFooterView = UIView(frame: CGRect.zero)

        usersTableView.isHidden = true
        applyDefaultStyleAndEnableStartButton()
        disableStartButton()
        startButton.addTarget(self, action: #selector(applyPressedStyle), for: .touchDown)
        startButton.addTarget(self, action: #selector(applyDefaultStyleAndEnableStartButton), for: .touchUpOutside)
        startButton.addTarget(self, action: #selector(applyDefaultStyleAndEnableStartButton), for: .touchUpInside)
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
        performSegue(withIdentifier: Segue.showMovieMatches.rawValue, sender: clone)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = Segue(initWith: segue) else {
            fatalError("unable to use Segue enum")
        }

        switch identifier {
        case .showMovieMatches:
            guard let nearbyMessages = sender as? [NearbyMessage] else {
                return
            }
            let vc = segue.destination as? MovieMatchViewController
            vc?.configure(with: nearbyMessages)
        default:
            return
        }
    }

    // MARK: - Nearby

    fileprivate func startPublishing() {
        let nearbyMovies =
            Dependencies
                .shared
                .movieStorage
                .fetchAllWantToSeeMovies()
                .compactMap { storedMovie -> NearbyMovie? in
                    guard let title = storedMovie.title else {
                        return nil
                    }
                    return NearbyMovie(id: storedMovie.id, title: title, posterPath: storedMovie.posterPath)
                }

        guard let username = UserDefaultsManager.getUsername() else {
            return
        }
        let nearbyMessage = NearbyMessage.create(withUsername: username, movies: nearbyMovies)
        myNearbyMessage = nearbyMessage
        guard let messageData = try? JSONEncoder().encode(nearbyMessage) else {
            return
        }
        currentPublication = Dependencies
            .shared
            .gnsMessageManager
            .publication(with: GNSMessage(content: messageData))
    }

    fileprivate func startSubscribing() {
        currentSubscription = Dependencies.shared.gnsMessageManager.subscription(
            messageFoundHandler: { message in
                guard let data = message?.content,
                let nearbyMessage = try? JSONDecoder().decode(NearbyMessage.self, from: data) else {
                    return
                }

                guard self.nearbyMessages.index(of: nearbyMessage) == nil else {
                    return
                }
                DispatchQueue.main.async {
                    self.nearbyMessages.append(nearbyMessage)
                    self.applyDefaultStyleAndEnableStartButton()
                    self.usersTableView.isHidden = false
                    self.usersTableView.reloadData()
                }
        }, messageLostHandler: { message in
            guard let data = message?.content,
                let nearbyMessage = try? JSONDecoder().decode(NearbyMessage.self, from: data) else {
                    return
            }

            guard let index = self.nearbyMessages.index(of: nearbyMessage) else {
                return
            }
            DispatchQueue.main.async {
                self.nearbyMessages.remove(at: index)
                if self.nearbyMessages.isEmpty {
                    self.disableStartButton()
                    self.usersTableView.isHidden = true
                }
                self.usersTableView.reloadData()
            }
        })
    }
}

extension MovieNightViewController {
    // MARK: Style button

    @objc
    func applyDefaultStyleAndEnableStartButton() {
        startButton.isEnabled = true
        startButton.tintColor = UIColor.primaryOrange
        startButton.layer.borderColor = UIColor.primaryOrange.cgColor
        startButton.layer.borderWidth = 4
        startButton.layer.cornerRadius = 25
    }

    @objc
    func disableStartButton() {
        startButton.isEnabled = false
        startButton.tintColor = UIColor.lightGray
        startButton.layer.borderColor = UIColor.lightGray.cgColor
    }

    @objc
    func applyPressedStyle() {
        startButton.tintColor = UIColor.white
        startButton.layer.borderColor = UIColor.white.cgColor
    }
}

extension MovieNightViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyMessages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieNightUserTableViewCell.cellIdentifier, for: indexPath) as? MovieNightUserTableViewCell else {
            fatalError("Unable to dequeue cell with identifier \(MovieNightUserTableViewCell.cellIdentifier)")
        }

        cell.configure(width: nearbyMessages[indexPath.row])

        return cell
    }
}

extension MovieNightViewController: Instantiable {
    static var storyboard: Storyboard { return .movieNight }
    static var storyboardID: String? { return "MovieNightViewController" }
}
