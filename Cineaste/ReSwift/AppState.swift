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

    var nearbyState = NearbyState()

    var ownNearbyMessage: NearbyMessage {
        let username = UserDefaults.standard.username ?? UUID().uuidString
        let nearbyMovies = movies
            .filter { !($0.watched ?? false) }
            .sorted { $0.title > $1.title }
            .compactMap(NearbyMovie.init)
        return NearbyMessage(with: username, movies: nearbyMovies)
    }
}

struct NearbyState: Equatable {
    var nearbyMessages: [NearbyMessage] = []
    var selectedNearbyMessages: [NearbyMessage] = []
}
