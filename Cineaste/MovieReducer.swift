//
//  MovieReducer.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 07.04.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import ReSwift

func movieReducer(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()

    guard let action = action as? MovieAction else {
        return state
    }

    switch action {
    case .load(let movies):
        assert(state.movies.isEmpty)
        state.movies = movies
    case .add(let movie):
        if !state.movies.filter({ $0.id == movie.id }).isEmpty {
            state.movies = state.movies
                .filter { $0.id != movie.id }
                .union([movie])
        } else {
            state.movies.insert(movie)
        }
    case .update(let movie):
        state.movies = state.movies
            .filter { $0.id != movie.id }
            .union([movie])
    case .delete(let movie):
        state.movies = state.movies.subtracting(
            state.movies.filter { $0.id == movie.id }
        )
    case .select(let movie):
        state.selectedMovieId = movie.id
    }
    return state
}
