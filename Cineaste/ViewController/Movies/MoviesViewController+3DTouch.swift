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
            let cell = tableView.cellForRow(at: path)
            else { return nil }

        previewingContext.sourceRect = cell.frame

        store.dispatch(SelectionAction.select(movie: filteredMovies[path.row]))
        return MovieDetailViewController.instantiate()
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {

        navigationController?.pushViewController(
            viewControllerToCommit,
            animated: true
        )
    }
}
