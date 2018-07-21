//
//  SearchMoviesViewController+Webservice.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 03.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

extension SearchMoviesViewController {
    func loadRecent(movies handler: @escaping ([Movie]) -> Void) {
        var pageToLoad = 1
        if let page = currentPage {
            pageToLoad = page + 1
        }

        Webservice.load(resource: Movie.latestReleases(page: pageToLoad)) { result in
            switch result {
            case .error:
                self.showAlert(withMessage: Alert.loadingDataError)
                handler([])
            case .success(let result):
                self.currentPage = result.page
                self.totalResults = result.totalResults
                handler(result.results)
            }
        }
    }

    func loadMovies(forQuery query: String?, handler: @escaping ([Movie]) -> Void) {
        if let query = query, !query.isEmpty {
            Webservice.load(resource: Movie.search(withQuery: query)) { result in
                switch result {
                case .error:
                    self.showAlert(withMessage: Alert.loadingDataError)
                    handler([])
                case .success(let movies):
                    handler(movies)
                }
            }
        } else {
            loadRecent { [weak self] movies in
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.moviesTableView.reloadData()
                }
            }
        }
    }

    func loadDetails(for movie: Movie, completionHandler handler: @escaping (Movie?) -> Void) {
        Webservice.load(resource: movie.get) { result in
            switch result {
            case .error:
                self.showAlert(withMessage: Alert.loadingDataError)
                handler(nil)
            case .success(let detailedMovie):
                detailedMovie.poster = movie.poster
                handler(detailedMovie)
            }
        }
    }
}
