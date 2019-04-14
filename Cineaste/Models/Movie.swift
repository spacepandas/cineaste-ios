//
//  Movie.swift
//  Cineaste
//
//  Created by Christian Braun on 18.10.17.
//  Copyright notimeforthat.org. All rights reserved.
//

import UIKit
import CoreData

struct Movie: Equatable {
    let id: Int64
    let title: String
    let voteAverage: Double
    let voteCount: Double
    let posterPath: String?
    let overview: String
    let runtime: Int16
    var releaseDate: Date?
    var poster: UIImage?

    //swiftlint:disable:next discouraged_optional_boolean
    var watched: Bool?
    var watchedDate: Date?

    var listPosition: Int = 0

    let popularity: Double?

    // This is only for creating a movie to use it with the webservice
    init(id: Int64) {
        self.id = id
        self.title = ""
        voteAverage = 0
        voteCount = 0
        overview = ""
        runtime = 0
        posterPath = nil
        popularity = 0
    }

    init(id: Int64,
         title: String,
         voteAverage: Double,
         voteCount: Double,
         posterPath: String?,
         overview: String,
         runtime: Int16,
         releaseDate: Date?,
         poster: UIImage?,
         //swiftlint:disable:next discouraged_optional_boolean
         watched: Bool?,
         watchedDate: Date?,
         listPosition: Int = 0,
         popularity: Double?) {
        self.id = id
        self.title = title
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.posterPath = posterPath
        self.overview = overview
        self.runtime = runtime
        self.releaseDate = releaseDate
        self.poster = poster

        self.watched = watched
        self.watchedDate = watchedDate

        self.listPosition = listPosition

        self.popularity = popularity
    }
}

extension Movie: Codable {
    enum CodingKeys: String, CodingKey {
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

        voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
            ?? 0

        voteCount = try container.decodeIfPresent(Double.self, forKey: .voteCount)
            ?? 0

        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        overview = try container.decode(String.self, forKey: .overview)

        runtime = try container.decodeIfPresent(Int16.self, forKey: .runtime)
            ?? 0

        if let releaseDateString = try container.decodeIfPresent(String.self, forKey: .releaseDate) {
            if let releaseDate = releaseDateString.dateFromImportedMoviesString {
                self.releaseDate = releaseDate
            } else if let releaseDate = releaseDateString.dateFromString {
                self.releaseDate = releaseDate
            }
        }

        watched = try container.decodeIfPresent(Bool.self, forKey: .watched)

        if let watchedDateString = try container.decodeIfPresent(String.self, forKey: .watchedDate) {
            guard let watchedDate = watchedDateString.dateFromImportedMoviesString else {
                throw StoredMovieDecodingError.dateFromString
            }
            self.watchedDate = watchedDate
        }

        listPosition = try container.decodeIfPresent(Int.self, forKey: .listPosition)
            ?? 0

        popularity = try container.decodeIfPresent(Double.self, forKey: .popularity)
    }
}

extension Movie: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
