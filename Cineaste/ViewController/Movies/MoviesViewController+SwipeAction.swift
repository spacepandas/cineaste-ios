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
        let movie = movies[editActionsForRowAt.row]

        let seenAction = SwipeAction.moveToSeen.rowAction(for: movie)
        let watchlistAction = SwipeAction.moveToWatchlist.rowAction(for: movie)
        let removeAction = SwipeAction.delete.rowAction(for: movie)

        let currentState = category.state
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
        let movie = movies[indexPath.row]

        let seenAction = SwipeAction.moveToSeen.contextualAction(for: movie)
        let watchlistAction = SwipeAction.moveToWatchlist.contextualAction(for: movie)

        let actions: [UIContextualAction]

        let currentState = category.state
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
        let removeAction = SwipeAction.delete.contextualAction(for: movie)

        return UISwipeActionsConfiguration(actions: [removeAction])
    }
}
