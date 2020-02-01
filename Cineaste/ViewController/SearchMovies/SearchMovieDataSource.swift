//
//  SearchMovieDataSource.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 19.01.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import UIKit

class SearchMovieDataSource: NSObject, UITableViewDataSource {
    enum Mode {
        case discover
        case manualSearch
    }

    var mode: Mode = .discover
    var movies: [Movie] = []
    var currentPage: Int?
    var totalResults: Int?

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard mode == .manualSearch else { return nil }

        switch section {
        case .tokens:
            return "Genres"
        case .movies:
            return "Movies"
        default:
            return nil
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        switch mode {
        case .discover:
            return 1
        case .manualSearch:
            return 2
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (mode, section) {
        case (.discover, _),
             (.manualSearch, .movies):
            return movies.count
        case (.manualSearch, .tokens):
            return 1
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch (mode, indexPath.section) {
        case (.discover, _),
             (.manualSearch, .movies):
            let cell: SearchMoviesCell = tableView.dequeueCell(identifier: SearchMoviesCell.identifier)

            let movie = movies[indexPath.row]

            cell.configure(with: movie)

            if let numberOfMovies = totalResults,
                indexPath.isLast(of: numberOfMovies) {
                tableView.tableFooterView = UIView()
            }

            return cell
        case (.manualSearch, .tokens):
            let cell: SearchTokenCell = tableView.dequeueCell(identifier: SearchTokenCell.identifier)
            cell.configure()
            return cell
        default:
            fatalError("The impossible has happened")
        }

    }
}

private extension Int {
    static let tokens = 0
    static let movies = 1
}
