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
    fileprivate(set) var releaseDate: Date?
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
}

extension Movie {
    static fileprivate let baseUrl = "https://api.themoviedb.org/3"
    static fileprivate let posterBaseUrl = "https://image.tmdb.org/t/p/w342"
    static fileprivate let apiKey = ApiKeyStore.theMovieDbKey()
    static fileprivate let locale = Locale.current.identifier

    static func search(withQuery query: String) -> Resource<[Movie]>? {
        guard let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            return nil
        }
        let urlAsString = "\(Movie.baseUrl)/search/movie?language=\(locale)&api_key=\(apiKey)&query=\(escapedQuery)"

        return Resource(url: urlAsString, method: .get) { data in
            let paginatedMovies = try? JSONDecoder().decode(PagedMovieResult.self, from: data)
            return paginatedMovies?.results
        }
    }

    static func latestReleases() -> Resource<[Movie]>? {
        let oneMonthInPast = Date(timeIntervalSinceNow: -60 * 60 * 24 * 30)
        let oneMonthInFuture = Date(timeIntervalSinceNow: 60 * 60 * 24 * 30)
        let urlAsString =
        "\(Movie.baseUrl)/discover/movie?" +
        "primary_release_date.gte=\(oneMonthInPast.formattedForRequest)&" +
            "primary_release_date.lte=\(oneMonthInFuture.formattedForRequest)&" +
            "language=\(Movie.locale)&" +
            "api_key=\(apiKey)"

        return Resource(url: urlAsString, method: .get) { data in
            do {
                let paginatedMovies = try JSONDecoder().decode(PagedMovieResult.self, from: data)
                return paginatedMovies.results
            } catch {
                print(error)
                return nil
            }
        }
    }

    static func loadPoster(from posterPath: String) -> Resource<UIImage>? {
        let urlAsString = "\(Movie.posterBaseUrl)\(posterPath)?api_key=\(Movie.apiKey)"
        return Resource(url: urlAsString, method: .get) { data in
            return UIImage(data: data)
        }
    }

    var get: Resource<Movie>? {
        let urlAsString = "\(Movie.baseUrl)/movie/\(id)?language=\(Movie.locale)&api_key=\(Movie.apiKey)"
        return Resource(url: urlAsString, method: .get) { data in
            do {
                let movie = try JSONDecoder().decode(Movie.self, from: data)
                return movie
            } catch {
                print(error)
                return nil
            }
        }
    }
}

extension Movie {
    var formattedVoteAverage: String {
        if self.voteCount == 0 {
            return Strings.unknownVoteAverage
        } else {
            return self.voteAverage.formattedWithOneFractionDigit
                ?? Strings.unknownVoteAverage
        }
    }

    var formattedReleaseDate: String {
        if let release = releaseDate {
            return release.formatted
        } else {
            return Strings.unknownReleaseDate
        }
    }

    var formattedRuntime: String {
        return "\(runtime.formatted ?? Strings.unknownRuntime) min"
    }
}
