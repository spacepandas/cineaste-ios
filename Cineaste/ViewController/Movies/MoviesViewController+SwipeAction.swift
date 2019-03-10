//
//  MoviesViewController+SwipeAction.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 28.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

extension MoviesViewController {

    // MARK: - iOS 10 functions

    // swiftlint:disable:next discouraged_optional_collection
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let movie = fetchedResultsManager.movies[editActionsForRowAt.row]

        let currentState = category.state

        let seenAction = SwipeAction.moveToSeen.rowAction {
            self.storageManager?.updateMovieItem(with: movie.objectID, watched: true) { result in
                guard case .success = result else {
                    self.showAlert(withMessage: Alert.updateMovieError)
                    return
                }
            }
        }

        let watchlistAction = SwipeAction.moveToWatchlist.rowAction {
            self.storageManager?.updateMovieItem(with: movie.objectID, watched: false) { result in
                guard case .success = result else {
                    self.showAlert(withMessage: Alert.updateMovieError)
                    return
                }
            }
        }

        let removeAction = SwipeAction.delete.rowAction {
            self.storageManager?.remove(with: movie.objectID) { result in
                guard case .success = result else {
                    self.showAlert(withMessage: Alert.deleteMovieError)
                    return
                }
            }
        }

        switch currentState {
        case .undefined:
            return []
        case .seen:
            return [removeAction, watchlistAction]
        case .watchlist:
            return [removeAction, seenAction]
        }
    }

    // MARK: - iOS 11 functions

    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let movie = fetchedResultsManager.movies[indexPath.row]

        let currentState = category.state

        let seenAction = SwipeAction.moveToSeen.contextualAction {
            self.storageManager?.updateMovieItem(with: movie.objectID, watched: true) { result in
                guard case .success = result else {
                    self.showAlert(withMessage: Alert.updateMovieError)
                    return
                }
            }
        }

        let watchlistAction = SwipeAction.moveToWatchlist.contextualAction {
            self.storageManager?.updateMovieItem(with: movie.objectID, watched: false) { result in
                guard case .success = result else {
                    self.showAlert(withMessage: Alert.updateMovieError)
                    return
                }
            }
        }

        let actions: [UIContextualAction]

        switch currentState {
        case .undefined:
            actions = []
        case .seen:
            actions = [watchlistAction]
        case .watchlist:
            actions = [seenAction]
        }

        return UISwipeActionsConfiguration(actions: actions)
    }

    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let movie = fetchedResultsManager.movies[indexPath.row]

        let removeAction = SwipeAction.delete.contextualAction {
            self.storageManager?.remove(with: movie.objectID) { result in
                guard case .success = result else {
                    self.showAlert(withMessage: Alert.deleteMovieError)
                    return
                }
            }
        }

        return UISwipeActionsConfiguration(actions: [removeAction])
    }
}
