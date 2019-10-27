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
        return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = movies[indexPath.row]
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
        store.dispatch(SelectionAction.select(movie: movies[indexPath.row]))
        perform(segue: .showMovieDetail, sender: nil)
    }

    @available(iOS 13.0, *)
    override func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        guard let idString = configuration.identifier as? String,
            let id = Int(idString)
            else { return }

        animator.addCompletion {
            let detailVC = MovieDetailViewController.instantiate()
            detailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    @available(iOS 13.0, *)
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let movie = movies[indexPath.row]

        let configuration = UIContextMenuConfiguration(
            identifier: "\(indexPath.row)" as NSCopying,
            previewProvider: {
                let detailVC = MovieDetailViewController.instantiate()
                detailVC.hidesBottomBarWhenPushed = true
                return detailVC
            }, actionProvider: { _ in
            let actions = ContextMenu.actions(for: movie)
            return UIMenu(title: "", image: nil, identifier: nil, children: actions)
            })

        return configuration
    }
}
