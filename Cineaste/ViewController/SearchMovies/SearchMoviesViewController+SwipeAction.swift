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
        guard let currentState = storageManager?.currentState(for: movie)
            else { return nil }

        let seenAction = SwipeAction.moveToSeen.contextualAction {
            self.shouldMark(movie: movie, state: .seen)
        }

        let watchlistAction = SwipeAction.moveToWatchlist.contextualAction {
            self.shouldMark(movie: movie, state: .watchlist)
        }

        let actions: [UIContextualAction]

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

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let movie = movies[indexPath.row]
        guard let currentState = storageManager?.currentState(for: movie)
            else { return nil }

        let removeAction = SwipeAction.delete.contextualAction {
            self.shouldMark(movie: movie, state: .undefined)
        }

        let actions: [UIContextualAction]

        if currentState == .undefined {
            actions = []
        } else {
            actions = [removeAction]
        }

        return UISwipeActionsConfiguration(actions: actions)
    }
}
