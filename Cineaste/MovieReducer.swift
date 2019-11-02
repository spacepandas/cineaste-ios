//
//  MovieReducer.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 07.04.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import ReSwift

// swiftlint:disable:next discouraged_optional_collection
func movieReducer(action: Action, state: Set<Movie>?) -> Set<Movie> {

    if action is ReSwiftInit {
        return Persistence.loadMovies()
    }

    var state = state ?? []

    switch action as? MovieAction {
    case .add(let movie)?:
        if !state.filter({ $0.id == movie.id }).isEmpty {
            // update movie when it already exists
            state = state
                .filter { $0.id != movie.id }
                .union([movie])
        } else {
            state.insert(movie)
        }
    case .update(let movie)?:
        state = state
            .filter { $0.id != movie.id }
            .union([movie])
    case .delete(let movie)?:
        state = state.subtracting(
            state.filter { $0.id == movie.id }
        )
    case nil:
        break
    }
    return state
}
