//
//  ImporterTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 26.12.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import XCTest
import CoreData
@testable import Cineaste_App

class ImporterTests: XCTestCase {
    let helper = CoreDataHelper()
    var storageManager: MovieStorageManager!

    override func setUp() {
        super.setUp()
        storageManager = MovieStorageManager(container: helper.mockPersistantContainer, useViewContext: true)
    }

    override func tearDown() {
        helper.flushData()
        super.tearDown()
    }

    func testImportMoviesFromUrlShouldImportMovies() {
        cleanImportOfMovies(from: "Import", expectedNumberOfMovies: 2)
    }

    func testImportMoviesFromUrlShouldImportMoviesFromAndroidExport() {
        cleanImportOfMovies(from: "AndroidExport", expectedNumberOfMovies: 3)
    }

    func testImportMoviesFromUrlShouldResultInErrorWhenImportingFailingJson() {
        let exp = expectation(description: "\(#function)\(#line)")

        assert(storageManager.persistentContainer.viewContext == storageManager.backgroundContext)

        // Given
        guard let path = Bundle(for: ImporterTests.self)
            .path(forResource: "FailingImport", ofType: "json")
            else {
                fatalError("Could not load file for resource FailingImport.json")
        }
        let urlToFailingImport = URL(fileURLWithPath: path)
        let movies = storageManager.fetchAll()
        precondition(movies.isEmpty,
                     "Test needs an empty database")

        // When
        Importer.importMovies(from: urlToFailingImport, storageManager: storageManager) { result in
            guard case let .error(error) = result else {
                XCTFail("Should not result in success")
                return
            }

            // Then
            XCTAssertNotNil(error)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)

        let importedMovies = storageManager.fetchAll()
        XCTAssert(importedMovies.isEmpty)
    }
}

extension ImporterTests {
    private func cleanImportOfMovies(from file: String, expectedNumberOfMovies: Int) {
        let exp = expectation(description: "\(#function)\(#line)")

        // Given
        guard let path = Bundle(for: ImporterTests.self)
            .path(forResource: file, ofType: "json")
            else {
                fatalError("Could not load file for resource \(file).json")
        }
        let urlToImport = URL(fileURLWithPath: path)
        let movies = storageManager.fetchAll()
        precondition(movies.isEmpty,
                     "Test needs an empty database")

        // When
        Importer.importMovies(from: urlToImport, storageManager: storageManager) { result in
            guard case let .success(numberOfMovies) = result else {
                XCTFail("Should not result in error")
                return
            }

            // Then
            XCTAssertEqual(numberOfMovies, expectedNumberOfMovies)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)

        let importedMovies = self.storageManager.fetchAll()
        XCTAssertEqual(importedMovies.count, expectedNumberOfMovies)
    }
}
