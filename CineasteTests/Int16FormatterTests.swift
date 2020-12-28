//
//  Int16FormatterTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 28.12.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import XCTest
@testable import Cineaste_App

class Int16FormatterTests: XCTestCase {

    func testFormattedShouldFormatInt16Correctly() {
        // Given
        let number: Int16 = 126
        let expected = "126"

        // When
        let formatted = number.formatted

        // Then
        XCTAssertEqual(expected, formatted)
    }

}
