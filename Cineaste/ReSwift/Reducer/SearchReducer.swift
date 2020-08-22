//
//  SearchReducer.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 20.06.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import ReSwift

// swiftlint:disable:next cyclomatic_complexity
func searchReducer(action: Action, state: SearchState?) -> SearchState {
    var state = state ?? SearchState()

    guard let action = action as? SearchAction
        else { return state }

    switch action {
    case .updateSearchQuery(let query):
        state.searchQuery = query
        state.currentPage = 1
        state.searchResult = []
        state.totalResults = nil
        state.currentRequest?.cancel()
    case .selectGenre(let genre):
        state.selectedGenres.append(genre)
        state.searchQuery = ""
        state.currentPage = 1
        state.searchResult = []
        state.totalResults = nil
        state.currentRequest?.cancel()
    case .deselectGenre(let genre):
        state.selectedGenres = state.selectedGenres.filter { $0 != genre }
        state.currentPage = 1
        state.searchResult = []
        state.totalResults = nil
        state.currentRequest?.cancel()
    case .showNextPage:
        if !state.hasLoadedAllMovies {
            state.currentPage += 1
        }
    case .updateMarkedMovie(let movie):
        if let index = state.searchResult.firstIndex(where: { $0.id == movie.id }) {
            state.searchResult[index] = movie
        }
        if let index = state.initialSearchResult.firstIndex(where: { $0.id == movie.id }) {
            state.initialSearchResult[index] = movie
        }
    case .updateSearchResult(let result):
        state.searchResult += result
    case .updateTotalResults(let totalResults):
        state.totalResults = totalResults
    case .updateNetworkRequest(let task):
        state.currentRequest = task
    case .setInitialSearchResult(let result):
        state.initialSearchResult += result
    case .resetSearch:
        let initialSearchResult = state.initialSearchResult
        state = SearchState(initialSearchResult: initialSearchResult)
    }

    return state
}
