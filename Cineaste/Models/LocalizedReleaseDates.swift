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

struct LocalizedReleaseDates: Decodable {
    var releaseDates: [ReleaseDate]

    struct ReleaseDate: Decodable {
        var identifier: String
        var releaseDate: Date?
    }

    init(from decoder: Decoder) throws {
        let rawResponse = try Decode(from: decoder)

        releaseDates = []

        for date in rawResponse.releaseDates.results {
            let date = ReleaseDate(
                identifier: date.identifier,
                releaseDate: date.releaseDates.first?.releaseDate
            )
            releaseDates.append(date)
        }
    }
}

//swiftlint:disable nesting
extension LocalizedReleaseDates {
    struct Decode: Decodable {
        var releaseDates: DecodeReleaseDates

        enum CodingKeys: String, CodingKey {
            case releaseDates = "release_dates"
        }

        struct DecodeReleaseDates: Decodable {
            var results: [LocalizedReleaseDate]

            struct LocalizedReleaseDate: Decodable {
                var identifier: String
                var releaseDates: [ReleaseDate]

                enum CodingKeys: String, CodingKey {
                    case identifier = "iso_3166_1"
                    case releaseDates = "release_dates"
                }
            }

            struct ReleaseDate: Decodable {
                var releaseDate: Date?

                enum CodingKeys: String, CodingKey {
                    case releaseDate = "release_date"
                }

                init(from decoder: Decoder) throws {
                    let container = try decoder
                        .container(keyedBy: CodingKeys.self)
                    let dateString = try container
                        .decodeIfPresent(String.self, forKey: .releaseDate)
                    releaseDate = dateString?.dateFromISO8601
                }
            }
        }
    }
}
//swiftlint:enable nesting
