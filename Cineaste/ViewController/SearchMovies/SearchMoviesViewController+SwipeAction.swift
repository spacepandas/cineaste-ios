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

    func action(for category: MovieListCategory, with movie: Movie) -> UITableViewRowAction {
        let newCategory: MovieListCategory =
            category == .seen
                ? .watchlist
                : .seen
        let newWatchedValue = newCategory == .seen

        let action = UITableViewRowAction(
        style: .normal,
        title: newCategory.action) { _, _ in
            self.shouldMark(movie: movie, watched: newWatchedValue)
        }
        action.backgroundColor = UIColor.basicYellow

        return action
    }

    // swiftlint:disable:next discouraged_optional_collection
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let movie = movies[editActionsForRowAt.row]

        let seenAction: UITableViewRowAction = action(for: .seen, with: movie)
        let watchlistAction: UITableViewRowAction = action(for: .watchlist, with: movie)
        return [seenAction, watchlistAction]
    }

    // MARK: - iOS 11 functions

    @available(iOS 11.0, *)
    func action(for category: MovieListCategory, with movie: Movie) -> UIContextualAction {
        let newCategory: MovieListCategory =
            category == .seen
                ? .watchlist
                : .seen
        let newWatchedValue = newCategory == .seen

        let action = UIContextualAction(
            style: .normal,
            title: newCategory.action) { (_, _, _: @escaping (Bool) -> Void) in
                self.shouldMark(movie: movie, watched: newWatchedValue)
        }

        action.image = newCategory.image
        action.backgroundColor = UIColor.basicYellow

        return action
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let movie = movies[indexPath.row]

        let watchlistAction: UIContextualAction = action(for: .watchlist, with: movie)
        return UISwipeActionsConfiguration(actions: [watchlistAction])
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let movie = movies[indexPath.row]

        let seenAction: UIContextualAction = action(for: .seen, with: movie)
        return UISwipeActionsConfiguration(actions: [seenAction])
    }
}
