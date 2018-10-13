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
            let predicate = NSPredicate(format: "title contains[c] '\(searchText)' AND \(category.predicate)")

            fetchedResultsManager.refetch(for: predicate)
        } else {
            fetchedResultsManager.refetch(for: category.predicate)
        }
        tableView.reloadData()
    }
}
