//
//  MovieNightViewController+UITableView.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 28.10.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit

extension MovieNightViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyMessages.isEmpty ? 0 : nearbyMessages.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieNightUserCell = tableView.dequeueCell(identifier: MovieNightUserCell.identifier)

        if indexPath.row == 0 {
            //all lists together

            var combinedMessages = nearbyMessages
            combinedMessages.append(ownNearbyMessage)

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
            var combinedMessages = nearbyMessages
            combinedMessages.append(ownNearbyMessage)

            performSegue(withIdentifier: Segue.showMovieMatches.rawValue,
                         sender: ("all", combinedMessages))
        } else {
            let nearbyMessage = nearbyMessages[indexPath.row - 1]
            performSegue(withIdentifier: Segue.showMovieMatches.rawValue,
                         sender: (nearbyMessage.userName, [nearbyMessage]))
        }
    }
}
