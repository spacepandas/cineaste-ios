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
        storageManager = MovieStorageManager(container: helper.mockPersistantContainer)
    }

    override func tearDown() {
        helper.flushData()
        super.tearDown()
    }

    func testImporterShouldImportMoviesFromJson() {
        let exp = expectation(description: "\(#function)\(#line)")

        // Given
        guard let path = Bundle(for: ImporterTests.self)
            .path(forResource: "Import", ofType: "json")
            else {
                fatalError("Could not load file for resource Import.json")
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
            XCTAssertEqual(numberOfMovies, 2)

            DispatchQueue.main.async {
                let movies = self.storageManager.fetchAll()
                XCTAssertEqual(movies.count, 2)
                exp.fulfill()
            }
        }

        wait(for: [exp], timeout: 1.0)
    }

    func testImporterShouldResultInErrorWhenImportingFailingJson() {
        let exp = expectation(description: "\(#function)\(#line)")

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

            DispatchQueue.main.async {
                let movies = self.storageManager.fetchAll()
                XCTAssert(movies.isEmpty)
                exp.fulfill()
            }
        }

        wait(for: [exp], timeout: 1.0)
    }
}
