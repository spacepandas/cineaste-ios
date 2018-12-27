//
//  ExporterTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 27.12.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import XCTest
import CoreData
@testable import Cineaste_App

class ExporterTests: XCTestCase {
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

    func testExportMoviesShouldSaveAsFileToExport() {
        let movies = storageManager.fetchAll()

        do {
            try Exporter.saveAsFileToExport(movies)
            defer {
                try! FileManager.default.removeItem(at: URL(fileURLWithPath: Exporter.exportPath))
            }

            let path = URL(fileURLWithPath: Exporter.exportPath)
            let testOutputData = try! Data(contentsOf: path)
            XCTAssertEqual(testOutputData, expectedOutputData)

            let testOutput = String(data: testOutputData, encoding: .utf8)
            let expectedOutput = String(data: expectedOutputData, encoding: .utf8)
            XCTAssertEqual(testOutput, expectedOutput)
        } catch {
            XCTFail("Test should not throw an error")
        }
    }

    private let expectedOutputData: Data = {
        guard let path = Bundle(for: ImporterTests.self).path(forResource: "Import", ofType: "json") else {
            fatalError("Could not load file for resource Import.json")
        }
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        return data
    }()
}
