//
//  DateFormatterTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 28.12.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import XCTest
@testable import Cineaste_App

class DateFormatterTests: XCTestCase {

    func testDatesShouldBeFormattedCorrectly() {
        // Given
        Current.locale = Locale(identifier: "en-US")
        // swiftlint:disable:next force_unwrapping
        Current.timeZone = TimeZone(abbreviation: "CET")!

        // 2020-12-28 09:49:53
        let testDate = Date(timeIntervalSince1970: 1_609_148_993)

        // When
        let pairs: [(String, String)] = [
            ("Dec 28, 2020", testDate.formatted),
            ("2020", testDate.formattedOnlyYear),
            ("December 28, 2020 at 10:49 AM", testDate.formattedWithTime),
            ("2020-12-28", testDate.formattedForRequest),
            ("Dec 28, 2020 09:49:53", testDate.formattedForJson)
        ]

        // Then
        for (expected, actual) in pairs {
            XCTAssertEqual(expected, actual)
        }
    }

}
