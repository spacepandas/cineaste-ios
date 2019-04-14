//
//  Movie.swift
//  Cineaste
//
//  Created by Christian Braun on 18.10.17.
//  Copyright notimeforthat.org. All rights reserved.
//

import UIKit
import CoreData

struct Movie: Codable, Equatable {
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

    let popularity: Double

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case posterPath = "poster_path"
        case overview
        case runtime
        case releaseDate = "release_date"
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

        let dateString = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        releaseDate = dateString?.dateFromString

        popularity = try container.decode(Double.self, forKey: .popularity)
    }

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
}

extension Movie: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
