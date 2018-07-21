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
        let detailVC = MovieDetailViewController.instantiate()
        guard let path = myMoviesTableView.indexPathForRow(at: location),
            let objects = fetchedResultsManager.controller?.fetchedObjects,
            objects.count > path.row
            else { return nil }

        let movie = objects[path.row]
        detailVC.storedMovie = movie
        detailVC.storageManager = storageManager
        detailVC.type = (category == MovieListCategory.seen) ? .seen : .wantToSee
        return detailVC
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}
