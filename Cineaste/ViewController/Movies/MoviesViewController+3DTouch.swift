//
//  MoviesViewController+3DTouch.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 14.07.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

extension MoviesViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {

        guard let path = tableView.indexPathForRow(at: location),
            let storageManager = storageManager,
            fetchedResultsManager.movies.count > path.row
            else { return nil }

        let detailVC = MovieDetailViewController.instantiate()
        detailVC.configure(with: .stored(fetchedResultsManager.movies[path.row]),
                           type: category.detailType,
                           storageManager: storageManager)
        return detailVC
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}
