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
        let movie = movies[indexPath.row]

        let seenAction = SwipeAction.moveToSeen.contextualAction(for: movie)
        let watchlistAction = SwipeAction.moveToWatchlist.contextualAction(for: movie)

        let actions: [UIContextualAction]

        switch movie.currentWatchState {
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
        let movie = movies[indexPath.row]
        let removeAction = SwipeAction.delete.contextualAction(for: movie)

        let actions: [UIContextualAction]

        if movie.currentWatchState == .undefined {
            actions = []
        } else {
            actions = [removeAction]
        }

        return UISwipeActionsConfiguration(actions: actions)
    }
}
