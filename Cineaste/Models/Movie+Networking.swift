//
//  Movie+Networking.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 10.07.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

extension Movie {
    fileprivate static let apiKey = ApiKeyStore.theMovieDbKey

    static func search(withQuery query: String, page: Int) -> Resource<PagedMovieResult> {
        guard let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            return latestReleases(page: page)
        }
        let urlAsString = "\(Constants.Backend.url)/search/movie" +
            "?language=\(String.languageFormattedForTMDb)" +
            "&api_key=\(apiKey)" +
            "&query=\(escapedQuery)" +
            "&region=\(String.regionIso31661)" +
            "&with_release_type=3" +
            "&page=\(page)"

        return Resource(url: urlAsString, method: .get) { data in
            do {
                let paginatedMovies = try JSONDecoder.tmdbDecoder
                    .decode(PagedMovieResult.self, from: data)
                return paginatedMovies
            } catch {
                print(error)
                return nil
            }
        }
    }

    static func latestReleases(page: Int) -> Resource<PagedMovieResult> {
        let oneMonthInPast = Date(timeIntervalSinceNow: -60 * 60 * 24 * 30)
        let oneMonthInFuture = Date(timeIntervalSinceNow: 60 * 60 * 24 * 30)
        let urlAsString = "\(Constants.Backend.url)/discover/movie" +
            "?api_key=\(apiKey)" +
            "&language=\(String.languageFormattedForTMDb)" +
            "&region=\(String.regionIso31661)" +
            "&release_date.gte=\(oneMonthInPast.formattedForRequest)" +
            "&release_date.lte=\(oneMonthInFuture.formattedForRequest)" +
            "&with_release_type=3" +
            "&page=\(page)"

        return Resource(url: urlAsString, method: .get) { data in
            do {
                return try JSONDecoder.tmdbDecoder
                    .decode(PagedMovieResult.self, from: data)
            } catch {
                print(error)
                return nil
            }
        }
    }

    static func posterUrl(from posterPath: String, for size: Constants.PosterSize) -> URL {
        let urlAsString = "\(size.address)\(posterPath)?api_key=\(apiKey)"
        guard let url = URL(string: urlAsString) else {
            fatalError("Could not create url for poster download")
        }
        return url
    }

    var get: Resource<Movie> {
        let urlAsString = "\(Constants.Backend.url)/movie/\(id)" +
            "?language=\(String.languageFormattedForTMDb)" +
            "&region=\(String.regionIso31661)" +
            "&api_key=\(Movie.apiKey)"

        return Resource(url: urlAsString, method: .get) { data in
            do {
                let sanitized = data.sanitizingReleaseDates()
                return try JSONDecoder.tmdbDecoder.decode(Movie.self, from: sanitized)
            } catch {
                print(error)
                return nil
            }
        }
    }

}
