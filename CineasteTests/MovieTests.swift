//
//  MovieTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 22.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import XCTest
@testable import Cineaste_App

class MovieTests: XCTestCase {

    func testDecodingFromNetwork() throws {
        // Given
        let expectedMovie = Movie.testing

        let jsonData = """
            {
              "adult": false,
              "backdrop_path": "/z2uuQasY4gQJ8VDAFki746JWeQJ.jpg",
              "belongs_to_collection": null,
              "budget": 0,
              "genres": [
                {
                  "id": 99,
                  "name": "Documentary"
                }
              ],
              "homepage": "https://www.nationalgeographic.com/films/free-solo/",
              "id": 515042,
              "imdb_id": "tt7775622",
              "original_language": "en",
              "original_title": "Free Solo",
              "overview": "Follow Alex Honnold as he attempts to become the first person to ever free solo climb Yosemite's 3,000 foot high El Capitan wall. With no ropes or safety gear, this would arguably be the greatest feat in rock climbing history.",
              "popularity": 7.582,
              "poster_path": "/v4QfYZMACODlWul9doN9RxE99ag.jpg",
              "production_companies": [
                {
                  "id": 7521,
                  "logo_path": "/fRqMjLjyAqThtEg9P9WKCXLmCpJ.png",
                  "name": "National Geographic",
                  "origin_country": "US"
                },
                {
                  "id": 49325,
                  "logo_path": null,
                  "name": "Parkes+MacDonald Image Nation",
                  "origin_country": ""
                },
                {
                  "id": 116323,
                  "logo_path": null,
                  "name": "Little Monster Films",
                  "origin_country": ""
                },
                {
                  "id": 384,
                  "logo_path": null,
                  "name": "MacDonald/Parkes Productions",
                  "origin_country": ""
                },
                {
                  "id": 117708,
                  "logo_path": null,
                  "name": "Itinerant Media",
                  "origin_country": ""
                },
                {
                  "id": 53299,
                  "logo_path": null,
                  "name": "Image Nation",
                  "origin_country": ""
                }
              ],
              "production_countries": [
                {
                  "iso_3166_1": "US",
                  "name": "United States of America"
                }
              ],
              "release_date": "2018-10-12",
              "revenue": 21790193,
              "runtime": 100,
              "spoken_languages": [
                {
                  "iso_639_1": "en",
                  "name": "English"
                }
              ],
              "status": "Released",
              "tagline": "Live beyond fear",
              "title": "Free Solo",
              "video": false,
              "vote_average": 8,
              "vote_count": 499
            }
            """
            .data(using: .utf8)!

        // When
        let movie = try JSONDecoder.tmdbDecoder.decode(
            Movie.self,
            from: jsonData
        )

        // Then
        XCTAssertEqual(movie, expectedMovie)
    }

    func testDecodingFromNetworkWithSanitizedReleaseDate() throws {
        // Given
        var expectedMovie = Movie.testing
        expectedMovie.releaseDate = Date.distantFuture

        let jsonData = """
            {
              "id": 515042,
              "overview": "Follow Alex Honnold as he attempts to become the first person to ever free solo climb Yosemite's 3,000 foot high El Capitan wall. With no ropes or safety gear, this would arguably be the greatest feat in rock climbing history.",
              "popularity": 7.582,
              "poster_path": "/v4QfYZMACODlWul9doN9RxE99ag.jpg",
              "release_date": "",
              "runtime": 100,
              "title": "Free Solo",
              "vote_average": 8,
              "vote_count": 499
            }
            """
            .data(using: .utf8)!

        // When
        let sanitized = jsonData.sanitizingReleaseDates()
        let movie = try JSONDecoder.tmdbDecoder.decode(
            Movie.self,
            from: sanitized
        )

        // Then
        XCTAssertEqual(movie, expectedMovie)
    }

    func testDecodingFromNetworkWithoutReleaseDate() throws {
        // Given
        var expectedMovie = Movie.testing

        //TODO: shouldn't this be Date.distantFuture as well?
        expectedMovie.releaseDate = nil

        let jsonData = """
            {
              "id": 515042,
              "overview": "Follow Alex Honnold as he attempts to become the first person to ever free solo climb Yosemite's 3,000 foot high El Capitan wall. With no ropes or safety gear, this would arguably be the greatest feat in rock climbing history.",
              "popularity": 7.582,
              "poster_path": "/v4QfYZMACODlWul9doN9RxE99ag.jpg",
              "release_date": null,
              "runtime": 100,
              "title": "Free Solo",
              "vote_average": 8,
              "vote_count": 499
            }
            """
            .data(using: .utf8)!

        // When
        let sanitized = jsonData.sanitizingReleaseDates()
        let movie = try JSONDecoder.tmdbDecoder.decode(
            Movie.self,
            from: sanitized
        )

        // Then
        XCTAssertEqual(movie, expectedMovie)
    }

}
