//
//  NSNumberFormatterTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 03.02.21.
//  Copyright © 2021 spacepandas.de. All rights reserved.
//

import XCTest
@testable import Cineaste_App

class NSNumberFormatterTests: XCTestCase {

    func testFormattedForPercentageShouldFormatNSNumberCorrectly() {
        // Given
        Current.locale = Locale(identifier: "en-US")
        let number: NSNumber = 0.1231
        let expected = "12%"

        // When
        let formatted = number.formattedForPercentage

        // Then
        XCTAssertEqual(expected, formatted)
    }

}
