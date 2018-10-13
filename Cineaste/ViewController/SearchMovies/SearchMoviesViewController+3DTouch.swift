//
//  SearchMoviesViewController+3DTouch.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 21.07.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit

extension SearchMoviesViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {

        guard let path = tableView.indexPathForRow(at: location),
            let storageManager = storageManager,
            movies.count > path.row
            else { return nil }

        let detailVC = MovieDetailViewController.instantiate()
        detailVC.configure(with: .network(movies[path.row]),
                           type: .search,
                           storageManager: storageManager)
        return detailVC
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit,
                                                 animated: true)
    }
}
