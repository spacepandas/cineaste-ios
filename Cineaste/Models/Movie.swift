//
//  Movie.swift
//  Cineaste
//
//  Created by Christian Braun on 18.10.17.
//  Copyright notimeforthat.org. All rights reserved.
//

import UIKit

struct Movie: Equatable {
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

extension Movie: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case posterPath = "poster_path"
        case overview
        case runtime
        case releaseDate = "release_date"
        case watched
        case watchedDate
        case listPosition
        case popularity
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int64.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage) ?? 0
        voteCount = try container.decodeIfPresent(Double.self, forKey: .voteCount) ?? 0
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? ""
        runtime = try container.decodeIfPresent(Int16.self, forKey: .runtime)

        if let dateString = try container.decodeIfPresent(String.self, forKey: .releaseDate) {
            if let date = DateFormatter.utcFormatter.date(from: dateString) {
                // Networking Movie
                releaseDate = date
            } else if let date = DateFormatter.importFormatter.date(from: dateString) {
                // Import Movie
                releaseDate = date
            } else {
                releaseDate = nil
            }
        }

        watched = try container.decodeIfPresent(Bool.self, forKey: .watched)

        if let watchedDateString = try container.decodeIfPresent(String.self, forKey: .watchedDate) {
            watchedDate = DateFormatter.importFormatter.date(from: watchedDateString)
        }

        listPosition = try container.decodeIfPresent(Int.self, forKey: .listPosition)
        popularity = try container.decodeIfPresent(Double.self, forKey: .popularity)
    }
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
