//
//  SearchMoviesViewController+UITableView.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 03.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

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

        // last cell for current page
        if indexPath.row == movies.count - 1 {
            guard let total = totalResults else {
                return UITableViewCell()
            }

            if total > movies.count {
                loadRecent { movies in
                    self.movies += movies
                }
            }

            // remove footerView with loading indicator 
            // on the very last item on the last page
            if indexPath.row == total - 1 {
                tableView.tableFooterView = nil
            }
        }

        cell.movie = movies[indexPath.row]
        cell.delegate = self
        return cell
    }
}
