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
        guard indexPaths.first(where: { $0.isLast(of: movies.count) }) != nil,
            let total = dataSource.totalResults
            else { return }

        if total > movies.count && !isLoadingNextPage {
            tableView.tableFooterView = loadingIndicatorView
            isLoadingNextPage = true

            loadMovies(forQuery: resultSearchController.searchBar.text, nextPage: true) { movies in
                DispatchQueue.main.async {
                    self.moviesFromNetworking.formUnion(movies)
                    self.isLoadingNextPage = false
                }
            }
        }
    }
}

extension SearchMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.row]
        store.dispatch(SelectionAction.select(movie: selectedMovie))
        perform(segue: .showMovieDetail, sender: self)
    }
}
