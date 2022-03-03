//
//  MovieThunks.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 20.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import Dispatch
import ReSwiftThunk

func markMovie(_ movie: Movie, watched: Bool) -> Thunk<AppState> {
    Thunk { dispatch, getState in

        var updatedMovie = movie

        if watched {
            updatedMovie.watched = true
            updatedMovie.watchedDate = Current.date()
        } else {
            updatedMovie.watched = false
        }

        let isNewMovie = getState()?.movies.filter { $0.id == movie.id }.isEmpty ?? true
        if isNewMovie {
            dispatch(MovieAction.add(movie: updatedMovie))
        } else {
            dispatch(MovieAction.update(movie: updatedMovie))
        }

        // Update Movie UI in Search
        dispatch(SearchAction.updateMarkedMovie(movie: updatedMovie))

        Webservice.load(resource: movie.get) { result in
            guard case let .success(detailedMovie) = result else { return }

            DispatchQueue.main.async {
                updatedMovie.update(withNew: detailedMovie)
                dispatch(MovieAction.update(movie: updatedMovie))
            }
        }

        AppStoreReview.requestReview()
    }
}

func deleteMovie(_ movie: Movie) -> Thunk<AppState> {
    Thunk { dispatch, _ in
        dispatch(MovieAction.delete(movie: movie))

        // Update Movie UI in Search
        var updatedMovie = movie
        updatedMovie.watched = nil
        updatedMovie.watchedDate = nil
        dispatch(SearchAction.updateMarkedMovie(movie: updatedMovie))

        SpotlightIndexing.deindexItem(movie)
    }
}
