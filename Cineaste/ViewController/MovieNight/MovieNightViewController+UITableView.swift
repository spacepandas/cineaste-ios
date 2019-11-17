//
//  MovieNightViewController+UITableView.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 28.10.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit

extension MovieNightViewController {
    enum Section: Int, CaseIterable {
        case allFriends
        case specificFriend
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard !nearbyMessages.isEmpty else { return 0 }

        return Section.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !nearbyMessages.isEmpty else { return 0 }

        switch Section(rawValue: section) {
        case .allFriends?:
            return 1
        case .specificFriend?:
            return nearbyMessages.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieNightUserCell = tableView.dequeueCell(identifier: MovieNightUserCell.identifier)

        switch Section(rawValue: indexPath.section) {
        case .allFriends?:
            var combinedMessages = nearbyMessages
            if let ownMessage = ownNearbyMessage {
                combinedMessages.append(ownMessage)
            }

            let numberOfAllMovies = combinedMessages
                .compactMap { $0.movies.count }
                .reduce(0, +)
            let names = combinedMessages.map { $0.userName }
            cell.configureAll(numberOfMovies: numberOfAllMovies,
                              namesOfFriends: names)
        case .specificFriend?:
            let message = nearbyMessages[indexPath.row]
            cell.configure(userName: message.userName,
                           numberOfMovies: message.movies.count)
        default:
            break
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section) {
        case .allFriends?:
            var combinedMessages = nearbyMessages
            if let ownMessage = ownNearbyMessage {
                combinedMessages.append(ownMessage)
            }

            performSegue(withIdentifier: Segue.showMovieMatches.rawValue,
                         sender: (String.allResultsForMovieNight, combinedMessages))
        case .specificFriend?:
            let nearbyMessage = nearbyMessages[indexPath.row]
            performSegue(withIdentifier: Segue.showMovieMatches.rawValue,
                         sender: (nearbyMessage.userName, [nearbyMessage]))
        default:
            break
        }
    }
}
