//
//  Movie.swift
//  Cineaste
//
//  Created by Christian Braun on 18.10.17.
//  Copyright notimeforthat.org. All rights reserved.
//

import UIKit

struct Movie: Codable, Equatable {
    let id: Int64
    let title: String
    let voteAverage: Double
    let voteCount: Double
    let posterPath: String?
    let overview: String
    let runtime: Int16?
    var releaseDate: Date?
    //swiftlint:disable:next discouraged_optional_boolean
    var watched: Bool?
    var watchedDate: Date?
    var listPosition: Int?
    let popularity: Double?
}

extension Movie {
    // This is only for creating a movie to use it with the webservice
    init(id: Int64) {
        self.id = id
        title = ""
        voteAverage = 0
        voteCount = 0
        overview = ""
        runtime = 0
        posterPath = nil
        popularity = 0
    }

    init(with nearbyMovie: NearbyMovie) {
        id = nearbyMovie.id
        title = nearbyMovie.title
        voteAverage = nearbyMovie.voteAverage
        voteCount = 0
        posterPath = nearbyMovie.posterPath
        overview = ""
        runtime = nearbyMovie.runtime
        releaseDate = nearbyMovie.releaseDate
        popularity = 0
    }
}

extension Movie: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Movie {
    var currentWatchState: WatchState {
        let state: WatchState
        if let watched = watched {
            state = watched ? .seen : .watchlist
        } else {
            state = .undefined
        }
        return state
    }
}
