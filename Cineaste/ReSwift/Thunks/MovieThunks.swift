//
//  MovieThunks.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 20.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import ReSwiftThunk

func updateMovie(with movie: Movie, markAsWatched: Bool) -> Thunk<AppState> {
    Thunk { dispatch, getState in

        var updatedMovie = movie
        if markAsWatched {
            updatedMovie.watched = true
            updatedMovie.watchedDate = Date()
        } else {
            updatedMovie.watched = false
        }

        let isNewMovie = getState()?.movies.filter { $0.id == movie.id }.isEmpty ?? true
        if isNewMovie {
            dispatch(MovieAction.add(movie: updatedMovie))
        } else {
            dispatch(MovieAction.update(movie: updatedMovie))
        }
    }
}
