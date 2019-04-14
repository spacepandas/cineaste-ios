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
        var movie = movies[editActionsForRowAt.row]

        let currentState = category.state

        let seenAction = SwipeAction.moveToSeen.rowAction {
            movie.watched = true
            store.dispatch(MovieAction.update(movie: movie))
        }

        let watchlistAction = SwipeAction.moveToWatchlist.rowAction {
            movie.watched = false
            store.dispatch(MovieAction.update(movie: movie))
        }

        let removeAction = SwipeAction.delete.rowAction {
            store.dispatch(MovieAction.delete(movie: movie))
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
        var movie = movies[indexPath.row]

        let currentState = category.state

        let seenAction = SwipeAction.moveToSeen.contextualAction {
            movie.watched = true
            store.dispatch(MovieAction.update(movie: movie))
        }

        let watchlistAction = SwipeAction.moveToWatchlist.contextualAction {
            movie.watched = false
            store.dispatch(MovieAction.update(movie: movie))
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
        let movie = movies[indexPath.row]

        let removeAction = SwipeAction.delete.contextualAction {
            store.dispatch(MovieAction.delete(movie: movie))
        }

        return UISwipeActionsConfiguration(actions: [removeAction])
    }
}
