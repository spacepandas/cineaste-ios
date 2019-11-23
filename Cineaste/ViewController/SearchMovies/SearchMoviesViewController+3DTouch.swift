//
//  SearchMoviesViewController+3DTouch.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 21.07.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit

extension SearchMoviesViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {

        guard let path = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: path)
            else { return nil }

        previewingContext.sourceRect = cell.frame

        store.dispatch(SelectionAction.select(movie: moviesWithoutWatchState[path.row]))
        return MovieDetailViewController.instantiate()
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {

        navigationController?.pushViewController(
            viewControllerToCommit,
            animated: true)
    }
}

@available(iOS 13.0, *)
extension SearchMoviesViewController {
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {

        guard let idString = configuration.identifier as? String,
            let id = Int(idString)
            else { return }

        animator.addCompletion {
            store.dispatch(SelectionAction.select(movie: self.moviesWithoutWatchState[id]))
            let detailVC = MovieDetailViewController.instantiate()
            detailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let movie = moviesWithoutWatchState[indexPath.row]

        let configuration = UIContextMenuConfiguration(
            identifier: "\(indexPath.row)" as NSCopying,
            previewProvider: {
                store.dispatch(SelectionAction.select(movie: movie))
                let detailVC = MovieDetailViewController.instantiate()
                detailVC.hidesBottomBarWhenPushed = true
                return detailVC
            }, actionProvider: { _ in
            let currentState = self.moviesWithWatchStates[movie] ?? .undefined
            let actions = ContextMenu.actions(for: movie, watchState: currentState, presenter: self)
            return UIMenu(title: "", image: nil, identifier: nil, children: actions)
            }
        )

        return configuration
    }

}
