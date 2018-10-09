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

        currentPage = nil
        totalResults = nil

        loadMovies { [weak self] movies in
            self?.movies = movies
            self?.scrollToTopCell(withAnimation: true)
        }
    }
}

extension SearchMoviesViewController: UISearchResultsUpdating {
    internal func updateSearchResults(for searchController: UISearchController) {
        searchDelayTimer?.invalidate()
        searchDelayTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] _ in
            self?.loadMovies(forQuery: searchController.searchBar.text) { movies in
                self?.movies = movies
                self?.scrollToTopCell(withAnimation: false)
            }
        }
    }
}
