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
        let movie = try JSONDecoder().decode(
            Movie.self,
            from: jsonData
        )

        // Then
        XCTAssertEqual(movie, expectedMovie)
    }

    func testDecodingFromNetworkWithEmptyReleaseDate() throws {
        // Given
        var expectedMovie = Movie.testing
        expectedMovie.releaseDate = nil

        let jsonData = """
            {
              "genres": [
                {
                  "id": 99,
                  "name": "Documentary"
                }
              ],
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
        let movie = try JSONDecoder().decode(
            Movie.self,
            from: jsonData
        )

        // Then
        XCTAssertEqual(movie, expectedMovie)
    }

    func testDecodingFromNetworkWithoutReleaseDate() throws {
        // Given
        var expectedMovie = Movie.testing
        expectedMovie.releaseDate = nil

        let jsonData = """
            {
              "genres": [
                {
                  "id": 99,
                  "name": "Documentary"
                }
              ],
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
        let movie = try JSONDecoder().decode(
            Movie.self,
            from: jsonData
        )

        // Then
        XCTAssertEqual(movie, expectedMovie)
    }

    func testDecodingWatchlistMovieFromImport() throws {
        // Given
        let expectedMovie = Movie.testingWatchlist

        let jsonData = """
            {
              "genres": [
                {
                  "id": 12,
                  "name": "Adventure"
                },
                {
                  "id": 16,
                  "name": "Animation"
                },
                {
                  "id": 10751,
                  "name": "Family"
                },
                {
                  "id": 10402,
                  "name": "Music"
                }
              ],
              "poster_path" : "/1P7zIGdv3Z0A5L6F30Qx0r69cmI.jpg",
              "release_date" : "Jan 23, 2000 00:00:00",
              "id" : 10898,
              "runtime" : 72,
              "title" : "The Little Mermaid II: Return to the Sea",
              "vote_count" : 898,
              "watched" : false,
              "listPosition" : 0,
              "vote_average" : 6.3,
              "overview" : "Set several years after the first film, Ariel and Prince Eric are happily married with a daughter, Melody. In order to protect Melody from the Sea Witch, Morgana, they have not told her about her mermaid heritage. Melody is curious and ventures into the sea, where she meets new friends. But will she become a pawn in Morgana\'s quest to take control of the ocean from King Triton?",
              "popularity" : 2.535
            }
            """
            .data(using: .utf8)!

        // When
        let movie = try JSONDecoder().decode(
            Movie.self,
            from: jsonData
        )

        // Then
        XCTAssertEqual(movie, expectedMovie)
    }

    func testEncodingWatchlistMovieForExport() throws {
        // Given
        let movie = Movie.testingWatchlist

        let expected = """
            {
              "genres": [
                {
                  "id": 12,
                  "name": "Adventure"
                },
                {
                  "id": 16,
                  "name": "Animation"
                },
                {
                  "id": 10751,
                  "name": "Family"
                },
                {
                  "id": 10402,
                  "name": "Music"
                }
              ],
              "poster_path" : "/1P7zIGdv3Z0A5L6F30Qx0r69cmI.jpg",
              "release_date" : "Jan 23, 2000 00:00:00",
              "id" : 10898,
              "runtime" : 72,
              "title" : "The Little Mermaid II: Return to the Sea",
              "vote_count" : 898,
              "watched" : false,
              "listPosition" : 0,
              "vote_average" : 6.3,
              "overview" : "Set several years after the first film, Ariel and Prince Eric are happily married with a daughter, Melody. In order to protect Melody from the Sea Witch, Morgana, they have not told her about her mermaid heritage. Melody is curious and ventures into the sea, where she meets new friends. But will she become a pawn in Morgana\'s quest to take control of the ocean from King Triton?",
              "popularity" : 2.535
            }
            """
            .data(using: .utf8)!

        // When
        let data = try JSONEncoder.tmdbEncoder.encode(movie)

        // Then
        XCTAssertEqual(
            try JSONSerialization.jsonObject(with: expected) as! NSDictionary,
            try JSONSerialization.jsonObject(with: data) as! NSDictionary
        )
    }

    func testDecodingHistoryMovieFromImport() throws {
        // Given
        let expectedMovie = Movie.testingSeen

        let jsonData = """
            {
              "genres": [
                {
                  "id": 16,
                  "name": "Animation"
                },
                {
                  "id": 10751,
                  "name": "Family"
                },
                {
                  "id": 14,
                  "name": "Fantasy"
                }
              ],
              "poster_path" : "/y0EOuK02TasfRGSZBdv5U910QaV.jpg",
              "release_date" : "Nov 17, 1989 00:00:00",
              "id" : 10144,
              "runtime" : 83,
              "title" : "The Little Mermaid",
              "vote_count" : 4529,
              "watched" : true,
              "listPosition" : 0,
              "vote_average" : 7.3,
              "overview" : "This colorful adventure tells the story of an impetuous mermaid princess named Ariel who falls in love with the very human Prince Eric and puts everything on the line for the chance to be with him. Memorable songs and characters -- including the villainous sea witch Ursula.",
              "watchedDate" : "Nov 17, 2017 20:49:26",
              "popularity" : 2166
            }
            """
            .data(using: .utf8)!

        // When
        let movie = try JSONDecoder().decode(
            Movie.self,
            from: jsonData
        )

        // Then
        XCTAssertEqual(movie, expectedMovie)
    }

    func testEncodingHistoryMovieForExport() throws {
        // Given
        let movie = Movie.testingSeen

        let expected = """
            {
              "genres": [
                {
                  "id": 16,
                  "name": "Animation"
                },
                {
                  "id": 10751,
                  "name": "Family"
                },
                {
                  "id": 14,
                  "name": "Fantasy"
                }
              ],
              "poster_path" : "/y0EOuK02TasfRGSZBdv5U910QaV.jpg",
              "release_date" : "Nov 17, 1989 00:00:00",
              "id" : 10144,
              "runtime" : 83,
              "title" : "The Little Mermaid",
              "vote_count" : 4529,
              "watched" : true,
              "listPosition" : 0,
              "vote_average" : 7.3,
              "overview" : "This colorful adventure tells the story of an impetuous mermaid princess named Ariel who falls in love with the very human Prince Eric and puts everything on the line for the chance to be with him. Memorable songs and characters -- including the villainous sea witch Ursula.",
              "watchedDate" : "Nov 17, 2017 20:49:26",
              "popularity" : 2166
            }
            """
            .data(using: .utf8)!

        // When
        let data = try JSONEncoder.tmdbEncoder.encode(movie)

        // Then
        XCTAssertEqual(
            try JSONSerialization.jsonObject(with: expected) as! NSDictionary,
            try JSONSerialization.jsonObject(with: data) as! NSDictionary
        )
    }

}
