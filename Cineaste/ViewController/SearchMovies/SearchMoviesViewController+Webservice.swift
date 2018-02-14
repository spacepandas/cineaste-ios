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
        Webservice.load(resource: Movie.latestReleases()) { result in
            guard case let .success(movies) = result else {
                // TODO: We should handle the error
                handler([])
                return
            }
            handler(movies)
        }
    }

    func loadMovies(forQuery query: String?, handler: @escaping ([Movie]) -> Void) {
        if let query = query, !query.isEmpty {
            Webservice.load(resource: Movie.search(withQuery: query)) { result in
                guard case let .success(movies) = result else {
                    // TODO: We should handle the error
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
                // TODO: We should handle the error
                return
            }
            detailedMovie.poster = movie.poster
            completionHandler(detailedMovie)
        }
    }
}
