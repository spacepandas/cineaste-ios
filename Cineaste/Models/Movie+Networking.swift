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
                let paginatedMovies = try JSONDecoder()
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
                return try JSONDecoder()
                    .decode(PagedMovieResult.self, from: data)
            } catch {
                print(error)
                return nil
            }
        }
    }

    var get: Resource<Movie> {
        let urlAsString = "\(Constants.Backend.url)/movie/\(id)" +
            "?language=\(String.languageFormattedForTMDb)" +
            "&region=\(String.regionIso31661)" +
            "&api_key=\(Movie.apiKey)" +
            "&append_to_response=release_dates"

        return Resource(url: urlAsString, method: .get) { data in
            do {
                let decoder = JSONDecoder()
                var movie = try decoder.decode(Movie.self, from: data)

                // only set localized release date if there is one
                if let releaseDate = try? decoder.decode(LocalizedReleaseDate.self, from: data).date {
                    movie.releaseDate = releaseDate
                }

                return movie
            } catch {
                print(error)
                return nil
            }
        }
    }
}
