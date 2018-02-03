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
        let newCategory: MovieListCategory = category == .seen ? .wantToSee : .seen
        let newWatchedValue = newCategory == .seen ? true : false

        let action = UITableViewRowAction(style: .normal, title: newCategory.title) { _, _ in
            self.storageManager.updateMovieItem(with: movie, watched: newWatchedValue, handler: { result in
                guard case .success = result else {
                    // TODO: We should definitely show an error when updating failed
                    return
                }
            })
        }
        action.backgroundColor = UIColor.basicYellow

        return action
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        guard let movies = fetchedResultsManager.controller?.fetchedObjects else {
            fatalError("Failure in loading fetchedObject")
        }

        let movie = movies[editActionsForRowAt.row]

        let categoryAction: UITableViewRowAction = action(for: category, with: movie)

        let deleteAction = UITableViewRowAction(style: .destructive, title: deleteActionTitle) { _, _ in
            self.storageManager.remove(movie, handler: { result in
                guard case .success = result else {
                    // TODO: We should definitely show an error when deletion failed
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
        let newCategory: MovieListCategory = category == .seen ? .wantToSee : .seen
        let newWatchedValue = newCategory == .seen ? true : false

        let action = UIContextualAction(style: .normal, title: newCategory.title, handler: { (_, _, success: @escaping (Bool) -> Void) in
            self.storageManager.updateMovieItem(with: movie, watched: newWatchedValue, handler: { result in
                guard case .success = result else {
                    // TODO: We should definitely show an error when updating failed
                    return
                }

                DispatchQueue.main.async {
                    success(true)
                }
            })
        })
        action.image = newCategory.image
        action.backgroundColor = UIColor.basicYellow

        return UISwipeActionsConfiguration(actions: [action])
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let movies = fetchedResultsManager.controller?.fetchedObjects else {
            fatalError("Failure in loading fetchedObject")
        }

        let movie = movies[indexPath.row]
        return action(for: category, with: movie)
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let movies = fetchedResultsManager.controller?.fetchedObjects else {
            fatalError("Failure in loading fetchedObject")
        }

        let movie = movies[indexPath.row]

        let deleteAction = UIContextualAction(style: .destructive, title: deleteActionTitle, handler: { (_, _, success: @escaping (Bool) -> Void) in
            self.storageManager.remove(movie, handler: { result in
                guard case .success = result else {
                    // TODO: We should definitely show an error when deletion failed
                    return
                }

                DispatchQueue.main.async {
                    success(true)
                }
            })
        })

        deleteAction.backgroundColor = UIColor.primaryOrange

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
