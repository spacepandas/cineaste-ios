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

    func testSaveAsFileToExportShouldSaveAFileWithMoviesAsJsonData() {
        //Given
        helper.initStubs()
        defer { helper.flushData() }

        let storageManager = MovieStorageManager(container: helper
            .mockPersistantContainer, useViewContext: true)

        guard let importPath = Bundle(for: ImporterTests.self)
            .path(forResource: "Import", ofType: "json"),
            let expectedOutputData = try? Data(
                contentsOf: URL(fileURLWithPath: importPath)
            ) else {
                fatalError("Something is wrong with mock Import.json")
        }
        let movies = storageManager.fetchAll()
        precondition(movies.count == 2,
                     "Test needs two movies to export")

        do {
            // When
            try Exporter.saveAsFileToExport(movies)
            defer {
                // remove file again after test
                try! FileManager.default.removeItem(at:
                    URL(fileURLWithPath: Exporter.exportPath))
            }

            // Then
            let path = URL(fileURLWithPath: Exporter.exportPath)
            let testOutputData = try! Data(contentsOf: path)
            XCTAssertEqual(testOutputData, expectedOutputData)

            let testOutput = String(data: testOutputData,
                                    encoding: .utf8)
            let expectedOutput = String(data: expectedOutputData,
                                        encoding: .utf8)
            XCTAssertEqual(testOutput, expectedOutput)
        } catch {
            XCTFail("Test should not throw an error")
        }
    }
}
