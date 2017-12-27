//
//  WantToSeeMoviesViewController+SwipeAction.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

extension WantToSeeMoviesViewController {
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
//        let movie = dataSource.fetchedObjects[editActionsForRowAt.row]

        let seenAction = UITableViewRowAction(style: .normal, title: "Seen") { _, _ in
            print("OK, marked as seen")
            AppDelegate.persistentContainer.performBackgroundTask { _ in
//                StoredMovie.insertOrUpdate(movie, watched: true, withContext: context)
            }
        }
        seenAction.backgroundColor = UIColor.basicYellow

        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { _, _ in
            print("Delete action ...")
            AppDelegate.persistentContainer.performBackgroundTask { _ in
//                StoredMovie.insertOrUpdate(movie, watched: false, withContext: context)
            }
        }
        deleteAction.backgroundColor = UIColor.primaryOrange

        return [deleteAction, seenAction]
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let movie = dataSource.fetchedObjects[indexPath.row]
        let seenAction = UIContextualAction(style: .normal, title: "Seen", handler: { (_, _, success: (Bool) -> Void) in
            print("OK, marked as seen")
            AppDelegate.persistentContainer.performBackgroundTask { _ in
//                StoredMovie.insertOrUpdate(movie, watched: true, withContext: context)
            }
            success(true)
        })
        seenAction.image = #imageLiteral(resourceName: "add_to_watchedlist")
        seenAction.backgroundColor = UIColor.basicYellow

        return UISwipeActionsConfiguration(actions: [seenAction])
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let movie = dataSource.fetchedObjects[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (_, _, success: (Bool) -> Void) in
            print("Delete action ...")
            AppDelegate.persistentContainer.performBackgroundTask { _ in
//                StoredMovie.insertOrUpdate(movie, watched: false, withContext: context)
            }
            success(true)
        })
        deleteAction.image = #imageLiteral(resourceName: "delete")
        deleteAction.backgroundColor = UIColor.primaryOrange

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
