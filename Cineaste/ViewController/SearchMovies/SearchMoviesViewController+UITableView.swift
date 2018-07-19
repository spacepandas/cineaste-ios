//
//  SearchMoviesViewController+UITableView.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 03.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

extension SearchMoviesViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        // last row on the current page
        let lastRow = indexPaths.first(where: { $0.row == movies.count - 1 })
        if lastRow != nil,
            let total = totalResults {
            if total > movies.count && !isLoadingNextPage {

                isLoadingNextPage = true
                loadRecent { movies in
                    self.movies += movies
                    self.isLoadingNextPage = false
                }
            }

            // last row on the last page
            let veryLastRow = indexPaths.first(where: { $0.row == total - 1 })
            if veryLastRow != nil {
                tableView.tableFooterView = nil
            }
        }
    }
}

extension SearchMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedMovie = movies[indexPath.row]
        perform(segue: .showMovieDetail, sender: self)
    }
}

extension SearchMoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchMoviesCell = tableView.dequeueCell(identifier: SearchMoviesCell.identifier)
        cell.movie = movies[indexPath.row]
        cell.delegate = self
        return cell
    }
}
