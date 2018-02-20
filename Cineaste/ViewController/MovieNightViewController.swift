//
//  MovieNightViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 07.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class MovieNightViewController: UIViewController {

    fileprivate var currentPublication: GNSPublication?
    fileprivate var currentSubscription: GNSSubscription?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Movie-Night", comment: "Title for movie night viewController")
        view.backgroundColor = UIColor.basicBackground

        startPublishing()
        startSubscribing()
    }

    // MARK: - Actions

    @IBAction func cancelButtonTouched(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Nearby

    fileprivate func startPublishing() {
        let nearbyMovies =
            Dependencies
                .shared
                .movieStorage
                .fetchAllWantToSeeMovies()
                .flatMap { storedMovie -> NearbyMovie? in
                    guard let title = storedMovie.title else {
                        return nil
                    }
                    return NearbyMovie(id: storedMovie.id, title: title, posterPath: storedMovie.posterPath)
                }

        // TODO: Make this pretty
        let nearbyMessage = NearbyMessage(userName: "It's me Mario", deviceId: "fancyDeviceId", movies: nearbyMovies)

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
                guard let data = message?.content else {
                    return
                }
                print(String(data: data, encoding: .utf8))
        }, messageLostHandler: { message in
            print("Lost \(message)")
        })
    }
}

extension MovieNightViewController: Instantiable {
    static var storyboard: Storyboard { return .movieNight }
    static var storyboardID: String? { return "MovieNightViewController" }
}
