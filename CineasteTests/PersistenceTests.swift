//
//  PersistenceTests.swift
//  CineasteTests
//
//  Created by Xaver Lohmüller on 17.04.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import XCTest
@testable import Cineaste_App

class PersistenceTests: XCTestCase {

    override func setUp() {
        super.setUp()
        try! cleanup()
    }

    override func tearDown() {
        try! cleanup()
        super.tearDown()
    }

    func testStoringMoviesShouldWriteJSONToTheDocumentsDirectory() throws {
        // Given
        let fileManager = FileManager.default
        let jsonUrl = fileManager.documentsDirectory.appendingPathComponent("movies.json")
        XCTAssertFalse(fileManager.fileExists(atPath: jsonUrl.path))
        let movies: Set<Movie> = [Movie(id: 1)]

        // When
        try Persistence.saveMovies(movies)

        // Then
        XCTAssert(fileManager.fileExists(atPath: jsonUrl.path))
    }

    func testLoadingMoviesShouldLoadMoviesFromJSON() throws {
        // Given
        let fileManager = FileManager.default
        let jsonUrl = fileManager.documentsDirectory.appendingPathComponent("movies.json")
        XCTAssertFalse(fileManager.fileExists(atPath: jsonUrl.path))
        try Persistence.saveMovies([Movie(id: 1)])

        // When
        let movies = Persistence.loadMovies()

        // Then
        XCTAssertFalse(movies.isEmpty)
    }

    func testUrlForMovieExportShouldGenerateJSONFileInCachesDirectory() throws {
        // Given
        let fileManager = FileManager.default
        try Persistence.saveMovies([Movie(id: 1)])

        // When
        let url = try Persistence.urlForMovieExport()

        // Then
        XCTAssert(fileManager.fileExists(atPath: url.path))
        let data = try Data(contentsOf: url)
        let exportedMovies = try JSONDecoder().decode(ImportExportObject.self, from: data).movies
        XCTAssertEqual(exportedMovies, Persistence.loadMovies())
    }

    private func cleanup() throws {
        let fileManager = FileManager.default
        for content in try fileManager.contentsOfDirectory(atPath: fileManager.documentsDirectory.path) {
            let url = fileManager.documentsDirectory.appendingPathComponent(content)
            try fileManager.removeItem(at: url)
        }
        for content in try fileManager.contentsOfDirectory(atPath: fileManager.cachesDirectory.path) {
            let url = fileManager.cachesDirectory.appendingPathComponent(content)
            try fileManager.removeItem(at: url)
        }
    }
}

private extension FileManager {
    var documentsDirectory: URL {
        // swiftlint:disable:next force_try
        return try! url(for: .documentDirectory,
                        in: .userDomainMask,
                        appropriateFor: nil,
                        create: false)
    }

    var cachesDirectory: URL {
        // swiftlint:disable:next force_try
        return try! url(for: .cachesDirectory,
                        in: .userDomainMask,
                        appropriateFor: nil,
                        create: false)
    }
}
