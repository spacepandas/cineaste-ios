//
//  SearchMoviesViewController+SwipeAction.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 28.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

extension SearchMoviesViewController {

    // MARK: - iOS 10 functions

    // swiftlint:disable discouraged_optional_collection
    func actions(for movie: Movie) -> [UITableViewRowAction]? {
        let currentState = storageManager?.currentState(for: movie)
        let actions: [UITableViewRowAction]?

        let seenAction = UITableViewRowAction(
            style: .normal,
            title: "Seen") { _, _ in
                self.shouldMark(movie: movie, state: .seen)
        }
        seenAction.backgroundColor = UIColor.primaryOrange

        let watchlistAction = UITableViewRowAction(
            style: .normal,
            title: "Watchlist") { _, _ in
                self.shouldMark(movie: movie, state: .watchlist)
        }
        watchlistAction.backgroundColor = UIColor.basicYellow

        let removeAction = UITableViewRowAction(
            style: .normal,
            title: "Remove") { _, _ in
                self.shouldMark(movie: movie, state: .undefined)
        }

        switch currentState {
        case .undefined?:
            actions = [seenAction, watchlistAction]
        case .seen?:
            actions = [removeAction, watchlistAction]
        case .watchlist?:
            actions = [removeAction, seenAction]
        default:
            actions = nil
        }

        return actions
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let movie = movies[editActionsForRowAt.row]
        return actions(for: movie)
    }
    // swiftlint:enable discouraged_optional_collection

    // MARK: - iOS 11 functions

    @available(iOS 11.0, *)
    func actionConfiguration(for movie: Movie) -> UISwipeActionsConfiguration? {
        guard let currentState = storageManager?.currentState(for: movie)
            else { return nil }
        let actions: [UIContextualAction]

        let seenAction = UIContextualAction(
            style: .normal,
            title: nil) { _, _, _  in
                self.shouldMark(movie: movie, state: .seen)
        }
        seenAction.backgroundColor = WatchState.seen.actionBackgroundColor
        seenAction.image = WatchState.seen.actionImage

        let watchlistAction = UIContextualAction(
            style: .normal,
            title: nil) { _, _, _  in
                self.shouldMark(movie: movie, state: .watchlist)
        }
        watchlistAction.backgroundColor = WatchState.watchlist.actionBackgroundColor
        watchlistAction.image = WatchState.watchlist.actionImage

        switch currentState {
        case .undefined:
            actions = [watchlistAction, seenAction]
        case .seen:
            actions = [watchlistAction]
        case .watchlist:
            actions = [seenAction]
        }

        let configuration = UISwipeActionsConfiguration(actions: actions)
        return configuration
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let movie = movies[indexPath.row]
        return actionConfiguration(for: movie)
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let movie = movies[indexPath.row]
        guard let currentState = storageManager?.currentState(for: movie)
            else { return nil }
        let actions: [UIContextualAction]

        let removeAction = UIContextualAction(
            style: .normal,
            title: WatchState.undefined.actionTitle) { _, _, _  in
                self.shouldMark(movie: movie, state: .undefined)
        }
        removeAction.backgroundColor = UIColor.primaryOrange

        if currentState == .undefined {
            actions = []
        } else {
            actions = [removeAction]
        }

        let configuration = UISwipeActionsConfiguration(actions: actions)
        return configuration
    }
}
