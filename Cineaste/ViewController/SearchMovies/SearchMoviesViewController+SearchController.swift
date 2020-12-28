//
//  SearchMoviesViewController+SearchController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 21.07.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit
import ReSwift

extension SearchMoviesViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        store.dispatch(SearchAction.resetSearch)
    }
}

extension SearchMoviesViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if #available(iOS 13, *) {
            dataSource.mode = .manualSearch
        } else {
            dataSource.mode = .discover
        }
        tableView.reloadData()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        dataSource.mode = .discover
        tableView.reloadData()
    }
}

extension SearchMoviesViewController: UISearchResultsUpdating {
    internal func updateSearchResults(for searchController: UISearchController) {
        searchDelayTimer?.invalidate()
        searchDelayTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
            store.dispatch(
                SearchAction.updateSearchQuery(
                    query: searchController.searchBar.text ?? ""
                )
            )
            store.dispatch(fetchSearchResults)
        }
    }
}
