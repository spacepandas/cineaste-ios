//
//  MoviesViewController+SwipeAction.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 28.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

extension MoviesViewController {
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let movie = filteredMovies[indexPath.row]

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

    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let movie = filteredMovies[indexPath.row]
        let removeAction = SwipeAction.delete.contextualAction(for: movie)

        return UISwipeActionsConfiguration(actions: [removeAction])
    }
}
