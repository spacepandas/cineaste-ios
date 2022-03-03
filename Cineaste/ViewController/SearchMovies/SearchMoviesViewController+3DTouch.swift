//
//  SearchMoviesViewController+3DTouch.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 21.07.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit

extension SearchMoviesViewController {
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        guard let indexPath = configuration.identifier as? IndexPath
            else { return }
        let id = indexPath.row
        let movie = movies[id]

        animator.addCompletion {
            store.dispatch(SelectionAction.select(movie: movie))
            let detailVC = MovieDetailViewController.instantiate()
            detailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let movie = movies[indexPath.row]

        let configuration = UIContextMenuConfiguration(
            identifier: indexPath as NSCopying,
            previewProvider: {
                store.dispatch(SelectionAction.select(movie: movie))
                let detailVC = MovieDetailViewController.instantiate()
                detailVC.hidesBottomBarWhenPushed = true
                return detailVC
            }, actionProvider: { _ in
                let cell = tableView.cellForRow(at: indexPath) ?? UITableViewCell()
                let actions = ContextMenu.actions(
                    for: movie,
                    presenter: self,
                    sourceView: cell.contentView
                )
                return UIMenu(title: "", image: nil, identifier: nil, children: actions)
            }
        )

        return configuration
    }

}
