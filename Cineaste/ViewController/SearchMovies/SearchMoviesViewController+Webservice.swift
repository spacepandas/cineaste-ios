//
//  SearchMoviesViewController+Webservice.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 03.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

extension SearchMoviesViewController {
    func loadMovies(forQuery query: String? = nil, nextPage: Bool = false, completion: @escaping (Set<Movie>) -> Void) {
        var pageToLoad = 1
        if let page = dataSource.currentPage, nextPage {
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
            case .failure(let error):
                self.showAlert(withMessage: Alert.loadingData(with: error))
                completion([])
            case .success(let result):
                self.dataSource.currentPage = result.page
                self.dataSource.totalResults = result.totalResults
                completion(result.results)
            }
        }
    }

    func loadDetails(for movie: Movie, completion: @escaping (Movie?) -> Void) {
        Webservice.load(resource: movie.get) { result in
            switch result {
            case .failure(let error):
                self.showAlert(withMessage: Alert.loadingData(with: error))
                completion(nil)
            case .success(let detailedMovie):
                completion(detailedMovie)
            }
        }
    }
}
