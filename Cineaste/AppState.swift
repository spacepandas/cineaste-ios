//
//  AppState.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 07.04.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import ReSwift

struct AppState: StateType, Equatable {
    var movies: Set<Movie> = []
    var selectedMovieId: Int64?

    var storedIDs: StoredMovieIDs {
        return StoredMovieIDs(
            watchListMovieIDs: movies.filter { !($0.watched ?? false) }.map { $0.id },
            seenMovieIDs: movies.filter { ($0.watched ?? true) }.map { $0.id }
        )
    }
}
