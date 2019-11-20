//
//  MovieThunks.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 20.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import ReSwiftThunk

func addMovie(_ movie: Movie) -> Thunk<AppState> {
    Thunk { dispatch, _ in
        dispatch(MovieAction.add(movie: movie))
        AppStoreReview.requestReview()
    }
}

func updateMovie(with movie: Movie, markAsWatched: Bool) -> Thunk<AppState> {
    Thunk { dispatch, _ in
        var movie = movie
        if markAsWatched {
            movie.watched = true
            movie.watchedDate = Date()
        } else {
            movie.watched = false
        }
        dispatch(MovieAction.update(movie: movie))
        AppStoreReview.requestReview()
    }
}

func updateMovie(with movie: Movie) -> Thunk<AppState> {
    Thunk { dispatch, _ in
        dispatch(MovieAction.update(movie: movie))
        AppStoreReview.requestReview()
    }
}

func deleteMovie(_ movie: Movie) -> Thunk<AppState> {
    Thunk { dispatch, _ in
        dispatch(MovieAction.delete(movie: movie))
        AppStoreReview.requestReview()
    }
}
