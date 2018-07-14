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
            let predicate = NSPredicate(format: "title contains[c] '\(searchText)'")

            fetchedResultsManager.refetch(for: predicate) {
                self.myMoviesTableView.reloadData()
            }
        } else {
            fetchedResultsManager.refetch(for: category.predicate) {
                self.myMoviesTableView.reloadData()
            }
        }
    }
}
