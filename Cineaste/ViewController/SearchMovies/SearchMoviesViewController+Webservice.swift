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

        print(pageToLoad)
        Webservice.load(resource: Movie.latestReleases(page: pageToLoad)) { result in
            guard case let .success(result) = result else {
                self.showAlert(withMessage: Alert.loadingDataError)
                handler([])
                return
            }
            self.currentPage = result.page
            self.totalResults = result.totalResults
            handler(result.results)
        }
    }

    func loadMovies(forQuery query: String?, handler: @escaping ([Movie]) -> Void) {
        if let query = query, !query.isEmpty {
            Webservice.load(resource: Movie.search(withQuery: query)) { result in
                guard case let .success(movies) = result else {
                    self.showAlert(withMessage: Alert.loadingDataError)
                    handler([])
                    return
                }
                handler(movies)
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

    func loadDetails(for movie: Movie, completionHandler: @escaping (Movie) -> Void) {
        Webservice.load(resource: movie.get) { result in
            guard case let .success(detailedMovie) = result else {
                self.showAlert(withMessage: Alert.loadingDataError)
                return
            }
            detailedMovie.poster = movie.poster
            completionHandler(detailedMovie)
        }
    }
}
