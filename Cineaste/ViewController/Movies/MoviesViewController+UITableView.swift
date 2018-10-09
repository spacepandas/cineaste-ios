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
        return fetchedResultsManager.movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch category {
        case .wantToSee:
            let cell: MovieListCell = tableView.dequeueCell(identifier: MovieListCell.identifier)
            cell.configure(with: fetchedResultsManager.movies[indexPath.row])
            return cell
        case .seen:
            let cell: SeenMovieCell = tableView.dequeueCell(identifier: SeenMovieCell.identifier)
            cell.configure(with: fetchedResultsManager.movies[indexPath.row])
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovie = fetchedResultsManager.movies[indexPath.row]
        perform(segue: .showMovieDetail, sender: nil)
    }
}
