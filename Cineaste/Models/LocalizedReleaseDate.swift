//
//  LocalizedReleaseDates.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 10.07.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

// Information:
// This model will parse the appended release dates from tmdb.org
// for more information see documentation here:
// https://developers.themoviedb.org/3/movies/get-movie-release-dates

// Conditions for correct date:
// - region identifier (iso_3166_1) has to be the current region
// - type has to be 3 (= Theatrical)
// - region identifier (iso_639_1) has to be empty (means, equal to the
// iso_3166_1 identifier) or equal the current region

// Example:
/*
 "release_dates": {
     "results": [
       {
         "iso_3166_1": "DE",
         "release_dates": [
           {
             "iso_639_1": "",
             "release_date": "1974-11-14T00:00:00.000Z",
             "type": 3
           }
 */

struct LocalizedReleaseDate: Decodable, Equatable {
    var date: Date?

    enum CodingKeys: String, CodingKey {
        case releaseDates = "release_dates"
        case results
    }

    init(from decoder: Decoder) throws {
        let container = try decoder
            .container(keyedBy: CodingKeys.self)
            .nestedContainer(keyedBy: CodingKeys.self, forKey: .releaseDates)

        let allReleaseDates = try container.decode(
            [InnerLocalizedReleaseDate].self, forKey: .results)
        let allRegionalReleaseDates = allReleaseDates
            .first { $0.identifier == String.regionIso31661 }
        date = allRegionalReleaseDates?.correctReleaseDate
    }
}

extension LocalizedReleaseDate {
    struct InnerLocalizedReleaseDate: Decodable {
        var identifier: String
        var regionReleaseDates: [ReleaseDate]

        // swiftlint:disable:next nesting
        enum CodingKeys: String, CodingKey {
            case identifier = "iso_3166_1"
            case regionReleaseDates = "release_dates"
        }

        var correctReleaseDate: Date? {
            regionReleaseDates.first {
                $0.type == 3 &&
                    ($0.regionIdentifier == String.languageIso6391 || $0.regionIdentifier.isEmpty)
            }?.regionReleaseDate
        }
    }

    struct ReleaseDate: Decodable {
        var regionIdentifier: String
        var regionReleaseDate: Date?
        var type: Int

        // swiftlint:disable:next nesting
        enum CodingKeys: String, CodingKey {
            case regionIdentifier = "iso_639_1"
            case regionReleaseDate = "release_date"
            case type
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            regionIdentifier = try container.decode(String.self, forKey: .regionIdentifier)
            regionReleaseDate = (try container.decodeIfPresent(
                String.self, forKey: .regionReleaseDate))?.dateFromISO8601String
            type = try container.decode(Int.self, forKey: .type)
        }
    }
}
