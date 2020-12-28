//
//  DateFormatterCineasteTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 28.12.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import XCTest
@testable import Cineaste_App

class DateFormatterCineasteTests: XCTestCase {

    func testUTCFormatterShouldReturnCorrectDateForString() {
        // Given
        let dateString = "1974-11-14"
        let expectedDate = Date(timeIntervalSince1970: 153_619_200)

        // When
        let date = DateFormatter.utcFormatter.date(from: dateString)

        // Then
        XCTAssertEqual(expectedDate, date)
    }

    func testImportFormatterShouldReturnCorrectDateForString() {
        // Given
        let dateString = "Dec 28, 2020 09:49:53"
        let expectedDate = Date(timeIntervalSince1970: 1_609_148_993)

        // When
        let date = DateFormatter.importFormatter.date(from: dateString)

        // Then
        XCTAssertEqual(expectedDate, date)
    }

}
