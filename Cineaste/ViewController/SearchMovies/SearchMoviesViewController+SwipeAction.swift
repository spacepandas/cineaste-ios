//
//  SearchMoviesViewController+SwipeAction.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 28.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

extension SearchMoviesViewController {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let movie = moviesWithoutWatchState[indexPath.row]

        let seenAction = SwipeAction.moveToSeen.contextualAction(for: movie)
        let watchlistAction = SwipeAction.moveToWatchlist.contextualAction(for: movie)

        let actions: [UIContextualAction]

        let currentState = moviesWithWatchStates[movie] ?? .undefined
        switch currentState {
        case .undefined:
            actions = [watchlistAction, seenAction]
        case .seen:
            actions = [watchlistAction]
        case .watchlist:
            actions = [seenAction]
        }

        return UISwipeActionsConfiguration(actions: actions)
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let movie = moviesWithoutWatchState[indexPath.row]
        let removeAction = SwipeAction.delete.contextualAction(for: movie)

        let actions: [UIContextualAction]

        let currentState = moviesWithWatchStates[movie] ?? .undefined
        if currentState == .undefined {
            actions = []
        } else {
            actions = [removeAction]
        }

        return UISwipeActionsConfiguration(actions: actions)
    }
}
