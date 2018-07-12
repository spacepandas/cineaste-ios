//
//  LocalizedReleaseDates.swift
//  Cineaste App-Dev
//
//  Created by Felizia Bernutz on 10.07.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import Foundation

// this model will parse the appended release dates from tmdb.org
// for more information see documentation here:
// https://developers.themoviedb.org/3/movies/get-movie-release-dates

struct LocalizedReleaseDate: Decodable {
    var date: Date?

    init(from decoder: Decoder) throws {
        let rawResponse = try ReleaseDateDto(from: decoder)

        // - region identifier (iso_3166_1) has to be the current region
        // - type has to be 3 (= Theatrical)
        // - region identifier (iso_639_1) has to be empty (means, equal to the
        // iso_3166_1 identifier) or equal the current region
        let allRegionReleaseDate = rawResponse
            .allReleaseDates
            .results
            .first(where: { $0.identifier == String.regionIso31661 })?
            .regionReleaseDates

        date = allRegionReleaseDate?
            .first(where: { $0.type == 3 &&
                ($0.regionIdentifier == String.regionIso31661 || $0.regionIdentifier.isEmpty) })?
            .regionReleaseDate
    }
}

//swiftlint:disable nesting
extension LocalizedReleaseDate {
    struct ReleaseDateDto: Decodable {
        var allReleaseDates: DecodeReleaseDates

        enum CodingKeys: String, CodingKey {
            case allReleaseDates = "release_dates"
        }

        struct DecodeReleaseDates: Decodable {
            var results: [LocalizedReleaseDate]

            struct LocalizedReleaseDate: Decodable {
                var identifier: String
                var regionReleaseDates: [ReleaseDate]

                enum CodingKeys: String, CodingKey {
                    case identifier = "iso_3166_1"
                    case regionReleaseDates = "release_dates"
                }
            }
        }
    }
}
//swiftlint:enable nesting

struct ReleaseDate: Decodable {
    var regionIdentifier: String
    var regionReleaseDate: Date?
    var type: Int

    enum CodingKeys: String, CodingKey {
        case regionIdentifier = "iso_639_1"
        case regionReleaseDate = "release_date"
        case type
    }
}

extension ReleaseDate {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        regionIdentifier = try container.decode(String.self,
                                                forKey: .regionIdentifier)

        let dateString = try container.decodeIfPresent(String.self,
                                                       forKey: .regionReleaseDate)
        regionReleaseDate = dateString?.dateFromISO8601

        type = try container.decode(Int.self, forKey: .type)
    }
}
