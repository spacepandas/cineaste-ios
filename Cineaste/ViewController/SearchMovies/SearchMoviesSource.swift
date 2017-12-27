//
//  SearchMoviesSource.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

final class SearchMoviesSource: NSObject {
    var movies: [Movie] = []
}

extension SearchMoviesSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchMoviesCell.identifier, for: indexPath) as? SearchMoviesCell else {
            fatalError("Unable to dequeue cell for identifier: \(SearchMoviesCell.identifier)")
        }

        cell.configure(with: movies[indexPath.row])
        return cell
    }
}
