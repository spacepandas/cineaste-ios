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

        helper.initStubs()
        storageManager = MovieStorageManager(container: helper.mockPersistantContainer)
    }

    override func tearDown() {
        helper.flushData()
        super.tearDown()
    }

    func testImporterShouldImportMoviesFromJson() {
        let exp = expectation(description: "\(#function)\(#line)")
        
        Importer.importMovies(from: urlToImport, storageManager: storageManager) { result in
            switch result {
            case .error:
                XCTFail("Should not result in error")
            case .success(let numberOfMovies):
                XCTAssertNotEqual(numberOfMovies, 4)
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    func testImporterShouldResultInErrorWhenImportingFailingJson() {
        let exp = expectation(description: "\(#function)\(#line)")

        Importer.importMovies(from: urlToFailingImport, storageManager: storageManager) { result in
            switch result {
            case .error(let error):
                XCTAssertNotNil(error)
            case .success:
                XCTFail("Should not result in success")
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    private let urlToImport: URL = {
        guard let path = Bundle(for: ImporterTests.self).path(forResource: "Import", ofType: "json") else {
            fatalError("Could not load file for resource Import.json")
        }
        return URL(fileURLWithPath: path)
    }()

    private let urlToFailingImport: URL = {
        guard let path = Bundle(for: ImporterTests.self).path(forResource: "FailingImport", ofType: "json") else {
            fatalError("Could not load file for resource FailingImport.json")
        }
        return URL(fileURLWithPath: path)
    }()
}
