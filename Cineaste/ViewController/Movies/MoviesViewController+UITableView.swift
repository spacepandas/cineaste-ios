//
//  MoviesViewController+UITableView.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 21.07.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit

extension MoviesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredMovies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = filteredMovies[indexPath.row]
        switch category {
        case .watchlist:
            let cell: WatchlistMovieCell = tableView.dequeueCell(identifier: WatchlistMovieCell.identifier)
            cell.configure(with: movie)
            return cell
        case .seen:
            let cell: SeenMovieCell = tableView.dequeueCell(identifier: SeenMovieCell.identifier)
            cell.configure(with: movie)
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        store.dispatch(SelectionAction.select(movie: filteredMovies[indexPath.row]))
        perform(segue: .showMovieDetail, sender: nil)
    }

    @available(iOS 13.0, *)
    override func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        guard let indexPath = configuration.identifier as? IndexPath
            else { return }
        let id = indexPath.row
        let movie = filteredMovies[id]

        animator.addCompletion {
            store.dispatch(SelectionAction.select(movie: movie))
            let detailVC = MovieDetailViewController.instantiate()
            detailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    @available(iOS 13.0, *)
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let movie = filteredMovies[indexPath.row]

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
