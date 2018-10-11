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

    func action(for category: MovieListCategory, with movie: StoredMovie) -> UITableViewRowAction {
        let newCategory: MovieListCategory =
            category == .seen
                ? .watchlist
                : .seen
        let newWatchedValue = newCategory == .seen

        let action = UITableViewRowAction(style: .normal, title: newCategory.action) { _, _ in
            self.storageManager?.updateMovieItem(with: movie, watched: newWatchedValue, handler: { result in
                guard case .success = result else {
                    self.showAlert(withMessage: Alert.updateMovieError)
                    return
                }
            })
        }
        action.backgroundColor = UIColor.basicYellow

        return action
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let movie = fetchedResultsManager.movies[editActionsForRowAt.row]

        let categoryAction: UITableViewRowAction = action(for: category, with: movie)

        let deleteAction = UITableViewRowAction(style: .destructive, title: String.deleteAction) { _, _ in
            self.storageManager?.remove(movie, handler: { result in
                guard case .success = result else {
                    self.showAlert(withMessage: Alert.deleteMovieError)
                    return
                }
            })
        }
        deleteAction.backgroundColor = UIColor.primaryOrange

        return [deleteAction, categoryAction]
    }

    // MARK: - iOS 11 functions

    @available(iOS 11.0, *)
    func action(for category: MovieListCategory, with movie: StoredMovie) -> UISwipeActionsConfiguration {
        let newCategory: MovieListCategory =
            category == .seen
                ? .watchlist
                : .seen
        let newWatchedValue = newCategory == .seen

        let action = UIContextualAction(style: .normal,
                                        title: newCategory.action) { (_, _, success: @escaping (Bool) -> Void) in
            self.storageManager?.updateMovieItem(with: movie, watched: newWatchedValue) { result in
                guard case .success = result else {
                    self.showAlert(withMessage: Alert.updateMovieError)
                    return
                }

                DispatchQueue.main.async {
                    success(true)
                }
            }
        }

        action.image = newCategory.image
        action.backgroundColor = UIColor.basicYellow

        return UISwipeActionsConfiguration(actions: [action])
    }

    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let movie = fetchedResultsManager.movies[indexPath.row]
        return action(for: category, with: movie)
    }

    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let movie = fetchedResultsManager.movies[indexPath.row]

        let deleteAction = UIContextualAction(style: .destructive,
                                              title: String.deleteAction) { (_, _, success: @escaping (Bool) -> Void) in
            self.storageManager?.remove(movie) { result in
                guard case .success = result else {
                    self.showAlert(withMessage: Alert.deleteMovieError)
                    return
                }

                DispatchQueue.main.async {
                    success(true)
                }
            }
        }

        deleteAction.backgroundColor = UIColor.primaryOrange

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
