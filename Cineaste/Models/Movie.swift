//
//  Movie.swift
//  Cineaste
//
//  Created by Christian Braun on 18.10.17.
//  Copyright notimeforthat.org. All rights reserved.
//

import Foundation

struct Movie: Equatable {
    let id: Int64
    let title: String
    let voteAverage: Double
    let voteCount: Double
    let posterPath: String?
    let overview: String
    let runtime: Int16?
    var releaseDate: Date?
    let genres: [Genre]
    // swiftlint:disable:next discouraged_optional_boolean
    var watched: Bool?
    var watchedDate: Date?
    var listPosition: Int?
    let popularity: Double?
}

struct Genre: Codable, Equatable {
    var id: Int
    var name: String
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
        case genres
        case watched
        case watchedDate
        case listPosition
        case popularity
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(forKey: .id)
        title = try container.decode(forKey: .title)
        voteAverage = try container.decode(forKey: .voteAverage, default: 0)
        voteCount = try container.decode(forKey: .voteCount, default: 0)
        posterPath = try container.decodeIfPresent(forKey: .posterPath)
        overview = try container.decode(forKey: .overview, default: "")
        runtime = try container.decodeIfPresent(forKey: .runtime)

        if let dateString: String = try container.decodeIfPresent(forKey: .releaseDate) {
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

        genres = try container.decode(forKey: .genres, default: [])
        watched = try container.decodeIfPresent(forKey: .watched)

        if let watchedDateString: String = try container.decodeIfPresent(forKey: .watchedDate) {
            watchedDate = DateFormatter.importFormatter.date(from: watchedDateString)
        }

        listPosition = try container.decodeIfPresent(forKey: .listPosition)
        popularity = try container.decodeIfPresent(forKey: .popularity)
    }
}

extension Movie: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Movie {

    ///  This is for creating a movie to use it with the webservice
    /// - Parameter id: movie id
    init(id: Int64) {
        self.id = id
        title = ""
        voteAverage = 0
        voteCount = 0
        overview = ""
        runtime = 0
        posterPath = nil
        popularity = 0
        genres = []
    }

    /// Update the information of a movie
    /// - Parameter movie: a new movie with update information
    mutating func update(withNew movie: Movie) {
        self = Movie(
            id: movie.id,
            title: movie.title,
            voteAverage: movie.voteAverage,
            voteCount: movie.voteCount,
            posterPath: movie.posterPath,
            overview: movie.overview,
            runtime: movie.runtime,
            releaseDate: movie.releaseDate,
            genres: movie.genres,
            watched: watched,
            watchedDate: watchedDate,
            popularity: movie.popularity
        )
    }

    /// The current watch state for a movie, computed with the watched property
    var currentWatchState: WatchState {
        let state: WatchState
        if let watched = watched {
            state = watched ? .seen : .watchlist
        } else {
            state = .undefined
        }
        return state
    }

    /// To indicate whether detail information are already loaded from network
    var hasAlreadyLoadedDetails: Bool {
        runtime != nil
    }

    static func posterUrl(from posterPath: String, for size: Constants.PosterSize) -> URL {
        let urlAsString = "\(size.address)\(posterPath)?api_key=\(ApiKeyStore.theMovieDbKey)"
        guard let url = URL(string: urlAsString) else {
            fatalError("Could not create url for poster download")
        }
        return url
    }

}
