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
        guard
            indexPaths.first(where: { $0.isLast(of: movies.count) }) != nil,
            let total = totalResults
            else { return }

        if total > movies.count && !isLoadingNextPage {
            moviesTableView.tableFooterView = loadingIndicatorView
            isLoadingNextPage = true

            loadMovies(forQuery: self.resultSearchController.searchBar.text, nextPage: true) { movies in
                self.movies += movies
                self.isLoadingNextPage = false
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

        if let numberOfMovies = totalResults,
            indexPath.isLast(of: numberOfMovies) {
            moviesTableView.tableFooterView = UIView()
        }

        cell.delegate = self
        return cell
    }
}
