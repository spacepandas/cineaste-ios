//
//  Movie.swift
//  Cineaste
//
//  Created by Christian Braun on 18.10.17.
//  Copyright notimeforthat.org. All rights reserved.
//

import UIKit
import CoreData

class Movie: Codable {
    fileprivate(set) var id: Int64
    fileprivate(set) var title: String
    fileprivate(set) var voteAverage: Decimal
    fileprivate(set) var voteCount: Float
    fileprivate(set) var posterPath: String?
    fileprivate(set) var overview: String
    fileprivate(set) var runtime: Int16
    var releaseDate: Date?
    var poster: UIImage?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case posterPath = "poster_path"
        case overview
        case runtime
        case releaseDate = "release_date"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int64.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)

        voteAverage = try container.decodeIfPresent(Decimal.self, forKey: .voteAverage)
            ?? 0.0

        voteCount = try container.decode(Float.self, forKey: .voteCount)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        overview = try container.decode(String.self, forKey: .overview)

        runtime = try container.decodeIfPresent(Int16.self, forKey: .runtime)
            ?? 0

        let dateString = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        releaseDate = dateString?.dateFromString
    }

    // This is only for creating a movie to use it with the webservice
    init(id: Int64, title: String) {
        self.id = id
        self.title = title
        self.voteAverage = 0
        self.voteCount = 0
        self.overview = ""
        self.runtime = 0
    }
}
