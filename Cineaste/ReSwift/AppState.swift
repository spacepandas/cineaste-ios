//
//  AppState.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 07.04.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import ReSwift
import Foundation

struct AppState: StateType, Equatable {
    var movies: Set<Movie> = []

    var storedIDs: StoredMovieIDs {
        StoredMovieIDs(
            watchListMovieIDs: movies.filter { !($0.watched ?? false) }.map { $0.id },
            seenMovieIDs: movies.filter { ($0.watched ?? true) }.map { $0.id }
        )
    }

    var selectedMovieState = SelectedMovieState()
    var searchState = SearchState()
}

struct SelectedMovieState: Equatable {
    var movie: Movie?
}

struct SearchState: Equatable {
    var selectedGenres: [Genre] = []
    var searchQuery: String = ""
    var currentPage: Int = 1
    var initialSearchResult: [Movie] = []
    var searchResult: [Movie] = []
    var totalResults: Int?
    weak var currentRequest: URLSessionTask?

    var isLoading: Bool {
        currentRequest != nil
    }

    var hasLoadedAllMovies: Bool {
        guard let totalResults = totalResults else { return false }
        return moviesToDisplay.count >= totalResults
    }

    var moviesToDisplay: [Movie] {
        isInitialSearch ? initialSearchResult : searchResult
    }

    var isInitialSearch: Bool {
        searchQuery.isEmpty && selectedGenres.isEmpty
    }
}
