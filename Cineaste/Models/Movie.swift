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
    fileprivate(set) var voteAverage: Float
    fileprivate(set) var posterPath: String?
    fileprivate(set) var overview: String
    fileprivate(set) var runtime: Int16
    fileprivate(set) var releaseDate: Date
    var poster: UIImage?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case overview
        case runtime
        case releaseDate = "release_date"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int64.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        voteAverage = try container.decode(Float.self, forKey: .voteAverage)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        overview = try container.decode(String.self, forKey: .overview)
        runtime = try container.decodeIfPresent(Int16.self, forKey: .runtime) ?? 0

        let dateString = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        releaseDate = dateString?.dateFromString ?? Date()
    }

    func encode(to encoder: Encoder) throws {
        fatalError("encode not implemented on \(Movie.self)")
    }
}

extension Movie {
    fileprivate static let apiKey = ApiKeyStore.theMovieDbKey()
    fileprivate static let locale = Locale.current.identifier

    static func search(withQuery query: String) -> Resource<[Movie]>? {
        guard let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            return nil
        }
        let urlAsString = "\(Config.Backend.url)/search/movie?language=\(locale)&api_key=\(apiKey)&query=\(escapedQuery)"

        return Resource(url: urlAsString, method: .get) {data in
            let paginatedMovies = try? JSONDecoder().decode(PagedMovieResult.self, from: data)
            return paginatedMovies?.results
        }
    }

    static func latestReleases() -> Resource<[Movie]>? {
        let oneMonthInPast = Date(timeIntervalSinceNow: -60 * 60 * 24 * 30)
        let oneMonthInFuture = Date(timeIntervalSinceNow: 60 * 60 * 24 * 30)
        let urlAsString =
        "\(Config.Backend.url)/discover/movie?" +
        "primary_release_date.gte=\(oneMonthInPast.formattedForRequest)&" +
            "primary_release_date.lte=\(oneMonthInFuture.formattedForRequest)&" +
            "language=\(Movie.locale)&" +
            "api_key=\(apiKey)"

        return Resource(url: urlAsString, method: .get) {data in
            let paginatedMovies = try? JSONDecoder().decode(PagedMovieResult.self, from: data)
            return paginatedMovies?.results
        }
    }

    func loadPoster() -> Resource<UIImage>? {
        guard let posterPath = posterPath else { return nil }
        let urlAsString = "\(Config.Backend.posterUrl)\(posterPath)?api_key=\(Movie.apiKey)"
        return Resource(url: urlAsString, method: .get) {data in
            let image = UIImage(data: data)
            return image
        }
    }

    var get: Resource<Movie>? {
        let urlAsString = "\(Config.Backend.url)/movie/\(id)?language=\(Movie.locale)&api_key=\(Movie.apiKey)"
        return Resource(url: urlAsString, method: .get) {data in
            let movie = try? JSONDecoder().decode(Movie.self, from: data)
            return movie
        }
    }
}
