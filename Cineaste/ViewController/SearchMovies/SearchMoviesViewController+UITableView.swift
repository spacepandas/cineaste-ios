//
//  SearchMoviesViewController+UITableView.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 03.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

extension SearchMoviesViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard indexPaths.contains(where: { $0.row >= movies.count - 1 }) else { return }
        print("prefetching...", indexPaths.map(\.row))

        store.dispatch(fetchSearchResults)
    }
}

extension SearchMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch (dataSource.mode, SearchSection(rawValue: indexPath.section)) {
        case (.discover, _),
             (.manualSearch, .movies?):
            let selectedMovie = movies[indexPath.row]
            store.dispatch(SelectionAction.select(movie: selectedMovie))
            perform(segue: .showMovieDetail, sender: self)
        case (.manualSearch, .tokens?):
            guard #available(iOS 13.0, *),
                let cell = tableView.cellForRow(at: indexPath) as? SearchTokenCell,
                let genre = cell.title.text
                else { return }

            let searchField = resultSearchController.searchBar.searchTextField
            let searchToken = UISearchToken(icon: UIImage.moreIcon, text: genre)
            searchField.insertToken(searchToken, at: 0)
            searchField.tokenBackgroundColor = .cineButton
        default:
            break
        }
    }
}
