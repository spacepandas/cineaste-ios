//
//  SearchMovieDataSource.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 19.01.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import UIKit

class SearchMovieDataSource: NSObject, UITableViewDataSource {

    var movies: [Movie] = []
    var currentPage: Int?
    var totalResults: Int?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchMoviesCell = tableView.dequeueCell(identifier: SearchMoviesCell.identifier)

        let movie = movies[indexPath.row]

        cell.configure(with: movie)

        if let numberOfMovies = totalResults,
            indexPath.isLast(of: numberOfMovies) {
            tableView.tableFooterView = UIView()
        }

        return cell
    }
}
