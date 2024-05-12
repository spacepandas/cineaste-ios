//
//  SearchThunks.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 20.06.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import Dispatch
import ReSwiftThunk

let fetchSearchResults = Thunk<AppState> { dispatch, getState in
    guard let state = getState()?.searchState,
        !state.hasLoadedAllMovies,
        !state.isLoading,
        let storedIDs = getState()?.storedIDs
        else { return }

    let resource: Resource<PagedMovieResult>?
    if state.isInitialSearch {
        resource = Movie.latestReleases(page: state.currentPage)
    } else {
        resource = Movie.search(withQuery: state.searchQuery, page: state.currentPage)
    }

    let task = Webservice.load(resource: resource) { result in
        DispatchQueue.main.async {
            dispatch(SearchAction.updateNetworkRequest(nil))
            switch result {
            case .failure(let error):
                break
            case .success(let result):
                let networkingMovies = result.results
                let movies = merge(networkingMovies, with: storedIDs)

                dispatch(SearchAction.showNextPage)
                dispatch(SearchAction.updateTotalResults(result.totalResults))
                let action: SearchAction = state.isInitialSearch
                    ? .setInitialSearchResult(result: movies)
                    : .updateSearchResult(result: movies)
                dispatch(action)
            }
        }
    }
    dispatch(SearchAction.updateNetworkRequest(task))
}

private func merge(_ networkMovies: Set<Movie>, with storedIDs: StoredMovieIDs) -> [Movie] {
    networkMovies.map { movie in
        var movie = movie
        if storedIDs.watchListMovieIDs.contains(movie.id) {
            movie.watched = false
        } else if storedIDs.seenMovieIDs.contains(movie.id) {
            movie.watched = true
        } else {
            movie.watched = nil
        }
        return movie
    }
    .sorted(by: SortDescriptor.sortByPopularity)
}
