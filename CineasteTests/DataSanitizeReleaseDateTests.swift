//
//  DataSanitizeReleaseDateTests.swift
//  CineasteTests
//
//  Created by Xaver Lohmüller on 01.06.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import XCTest
@testable import Cineaste_App

class DataSanitizeReleaseDateTests: XCTestCase {
    func testSanitizingShouldCleanReleaseDatesInJSONFiles() {
        // Given
        let data = """
        [
            { "release_date":"" },
            { "release_date":"" }
        ]
        """.data(using: .utf8)!
        let expected = """
        [
            { "release_date":null },
            { "release_date":null }
        ]
        """.data(using: .utf8)!

        // When
        let sanitized = data.sanitizingReleaseDates()

        // Then
        XCTAssertEqual(sanitized, expected)
    }

    func testSanitizingShouldLeaveRegularReleaseDatesAlone() {
        // Given
        let data = """
        [
            { "release_date":"2019-06-01" },
            { "release_date":null }
        ]
        """.data(using: .utf8)!

        // When
        let sanitized = data.sanitizingReleaseDates()

        // Then
        XCTAssertEqual(sanitized, data)
    }
}
