//
//  StringDateFormatterTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 28.12.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import XCTest
@testable import Cineaste_App

class StringDateFormatterTests: XCTestCase {

    func testDateFromISO8601StringShouldReturnDateWhenValid() {
        // Given
        let dateString = "1974-11-15T00:00:00.000Z"
        let expectedDate = Date(timeIntervalSince1970: 153_705_600)

        // When
        let date = dateString.dateFromISO8601String

        // Then
        XCTAssertEqual(expectedDate, date)
    }

    func testDateFromISO8601StringShouldReturnNilWhenInvalid() {
        // Given
        let dateString = ""

        // When
        let date = dateString.dateFromISO8601String

        // Then
        XCTAssertNil(date)
    }
}
