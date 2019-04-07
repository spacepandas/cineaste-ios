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
    case .add(let movie),
         .update(let movie):
        state.movies.update(with: movie)
    case .delete(let movie):
        state.movies.remove(movie)
    }
    return state
}
