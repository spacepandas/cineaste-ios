//
//  SearchMoviesViewController+Webservice.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 03.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

extension SearchMoviesViewController {
    func loadMovies(forQuery query: String? = nil, nextPage: Bool = false, completion: @escaping ([Movie]) -> Void) {
        var pageToLoad = 1
        if let page = currentPage, nextPage {
            pageToLoad = page + 1
        }

        let resource: Resource<PagedMovieResult>?
        if let query = query, !query.isEmpty {
            resource = Movie.search(withQuery: query, page: pageToLoad)
        } else {
            resource = Movie.latestReleases(page: pageToLoad)
        }

        Webservice.load(resource: resource) { result in
            switch result {
            case .failure:
                self.showAlert(withMessage: Alert.loadingDataError)
                completion([])
            case .success(let result):
                self.currentPage = result.page
                self.totalResults = result.totalResults
                completion(result.results)
            }
        }
    }

    func loadDetails(for movie: Movie, completion: @escaping (Movie?) -> Void) {
        Webservice.load(resource: movie.get) { result in
            switch result {
            case .failure:
                self.showAlert(withMessage: Alert.loadingDataError)
                completion(nil)
            case .success(var detailedMovie):
                detailedMovie.poster = movie.poster
                completion(detailedMovie)
            }
        }
    }
}
