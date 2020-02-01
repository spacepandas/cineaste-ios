//
//  SearchMoviesViewController+SearchController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 21.07.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit

extension SearchMoviesViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else { return }

        dataSource.currentPage = nil
        dataSource.totalResults = nil

        loadMovies { [weak self] movies in
            DispatchQueue.main.async {
                self?.moviesFromNetworking = movies
                self?.scrollToTopCell(withAnimation: true)
            }
        }
    }
}

extension SearchMoviesViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        dataSource.mode = .manualSearch
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
        searchDelayTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] _ in
            self?.loadMovies(forQuery: searchController.searchBar.text) { movies in
                DispatchQueue.main.async {
                    self?.moviesFromNetworking = movies
                    self?.scrollToTopCell(withAnimation: false)
                }
            }
        }
    }
}
