//
//  MoviesViewController+SearchController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 14.07.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

extension MoviesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }

        if !searchText.isEmpty {
            filteredMovies = movies
                .filter {
                    $0.title.contains(searchText)
                    && $0.watched == category.watched
                }
        } else {
            filteredMovies = movies.filter { $0.watched == category.watched }
        }
    }
}
