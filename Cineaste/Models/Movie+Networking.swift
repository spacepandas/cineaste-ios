//
//  Movie+Networking.swift
//  Cineaste App-Dev
//
//  Created by Felizia Bernutz on 10.07.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

extension Movie {
    fileprivate static let apiKey = ApiKeyStore.theMovieDbKey()

    static func search(withQuery query: String) -> Resource<[Movie]>? {
        guard let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            return nil
        }
        let urlAsString = "\(Config.Backend.url)/search/movie" +
            "?language=\(String.languageFormattedForTMDb)" +
            "&api_key=\(apiKey)" +
            "&query=\(escapedQuery)" +
            "&region=\(String.regionIso31661)" +
        "&with_release_type=3"

        return Resource(url: urlAsString, method: .get) { data in
            do {
                let paginatedMovies = try JSONDecoder()
                    .decode(PagedMovieResult.self, from: data)
                return paginatedMovies.results
            } catch {
                print(error)
                return nil
            }
        }
    }

    static func latestReleases(page: Int) -> Resource<PagedMovieResult>? {
        let oneMonthInPast = Date(timeIntervalSinceNow: -60 * 60 * 24 * 30)
        let oneMonthInFuture = Date(timeIntervalSinceNow: 60 * 60 * 24 * 30)
        let urlAsString = "\(Config.Backend.url)/discover/movie" +
            "?api_key=\(apiKey)" +
            "&language=\(String.languageFormattedForTMDb)" +
            "&region=\(String.regionIso31661)" +
            "&release_date.gte=\(oneMonthInPast.formattedForRequest)" +
            "&release_date.lte=\(oneMonthInFuture.formattedForRequest)" +
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

    static func posterUrl(from posterPath: String, for size: Config.PosterSize) -> URL {
        let urlAsString = "\(size.address)\(posterPath)?api_key=\(apiKey)"
        guard let url = URL(string: urlAsString) else {
            fatalError("Could not create url for poster download")
        }
        return url
    }

    var get: Resource<Movie>? {
        let urlAsString = "\(Config.Backend.url)/movie/\(id)" +
            "?language=\(String.languageFormattedForTMDb)" +
            "&api_key=\(Movie.apiKey)" +
        "&append_to_response=release_dates"

        return Resource(url: urlAsString, method: .get) { data in
            do {
                let decoder = JSONDecoder()
                let movie = try decoder.decode(Movie.self, from: data)

                let release = try? decoder.decode(LocalizedReleaseDate.self,
                                                  from: data)
                movie.releaseDate = release?.date

                return movie
            } catch {
                print(error)
                return nil
            }
        }
    }
}
