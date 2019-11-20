//
//  ImporterTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 26.12.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import XCTest
import ReSwift
@testable import Cineaste_App

class ImporterTests: XCTestCase {

    func testDecoding() throws {
        // Given
        let expectedMovie = Movie(
            id: 155,
            title: "The Dark Knight",
            voteAverage: 8.4,
            voteCount: 19_180,
            posterPath: #"/1hRoyzDtpgMU7Dz4JF22RANzQO7.jpg"#,
            overview: "Batman raises the stakes in his war on crime. With the help of Lt. Jim Gordon and District Attorney Harvey Dent, Batman sets out to dismantle the remaining criminal organizations that plague the streets. The partnership proves to be effective, but they soon find themselves prey to a reign of chaos unleashed by a rising criminal mastermind known to the terrified citizens of Gotham as the Joker.",
            runtime: 152,
            releaseDate: Date(timeIntervalSince1970: 1_219_190_400),
            watched: true,
            watchedDate: Date(timeIntervalSince1970: 1_562_358_721),
            listPosition: 0,
            popularity: nil)

        let jsonData = #"""
            {
              "poster_path" : "\/1hRoyzDtpgMU7Dz4JF22RANzQO7.jpg",
              "release_date" : "Aug 20, 2008 02:00:00",
              "id" : 155,
              "runtime" : 152,
              "title" : "The Dark Knight",
              "vote_count" : 19180,
              "watched" : true,
              "listPosition" : 0,
              "vote_average" : 8.4000000000000004,
              "overview" : "Batman raises the stakes in his war on crime. With the help of Lt. Jim Gordon and District Attorney Harvey Dent, Batman sets out to dismantle the remaining criminal organizations that plague the streets. The partnership proves to be effective, but they soon find themselves prey to a reign of chaos unleashed by a rising criminal mastermind known to the terrified citizens of Gotham as the Joker.",
              "watchedDate" : "Jul 05, 2019 22:32:01"
            }
            """#
            .data(using: .utf8)!

        // When
        let movie = try JSONDecoder.importDecoder.decode(
            Movie.self,
            from: jsonData
        )

        // Then
        XCTAssertEqual(movie, expectedMovie)
    }

    func testImportMoviesFromUrlShouldImportMovies() {
        XCTAssertNoThrow(try cleanImportOfMovies(from: "Import",
                                                 expectedNumberOfMovies: 2))
    }

    func testImportMoviesFromUrlShouldImportMoviesFromAndroidExport() {
        XCTAssertNoThrow(try cleanImportOfMovies(from: "AndroidExport",
                                                 expectedNumberOfMovies: 3))
    }

    func testImportMoviesFromUrlShouldResultInErrorWhenImportingFailingJson() {
        // Given
        guard let path = Bundle(for: ImporterTests.self)
            .path(forResource: "FailingImport", ofType: "json")
            else {
                fatalError("Could not load file for resource FailingImport.json")
        }
        let urlToFailingImport = URL(fileURLWithPath: path)
        var actions: [MovieAction] = []
        store.dispatchFunction = { action in
            if let action = action as? MovieAction {
                actions.append(action)
            }
        }

        // When
        XCTAssertThrowsError(try Importer.importMovies(from: urlToFailingImport))

        // Then
        XCTAssertEqual(actions.count, 0)
    }
}

extension ImporterTests {
    private func cleanImportOfMovies(from file: String, expectedNumberOfMovies: Int) throws {
        // Given
        guard let path = Bundle(for: ImporterTests.self)
            .path(forResource: file, ofType: "json")
            else {
                fatalError("Could not load file for resource \(file).json")
        }
        let urlToImport = URL(fileURLWithPath: path)
        var actions: [MovieAction] = []
        store.dispatchFunction = { action in
            if let action = action as? MovieAction {
                actions.append(action)
            }
        }

        // When
        let amountOfImportedMovies = try Importer.importMovies(from: urlToImport)

        // Then
        XCTAssertEqual(actions.count, expectedNumberOfMovies)
        XCTAssertEqual(amountOfImportedMovies, expectedNumberOfMovies)
    }
}
