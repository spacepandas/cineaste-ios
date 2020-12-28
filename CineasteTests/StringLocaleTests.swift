//
//  StringLocaleTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 28.12.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import XCTest
@testable import Cineaste_App

class StringLocaleTests: XCTestCase {

    func testRegionIso31661ShouldReturnRegion() {
        // Given
        Current.locale = Locale(identifier: "en-US")
        let expected = "US"

        // When
        let region = String.regionIso31661

        // Then
        XCTAssertEqual(region, expected)
    }

    func testLanguageIso6391ShouldReturnLanguage() {
        // Given
        Current.locale = Locale(identifier: "en-US")
        let expected = "en"

        // When
        let language = String.languageIso6391

        // Then
        XCTAssertEqual(language, expected)
    }

    func testLanguageFormattedForTMDbShouldReturnLanguageInCorrectFormat() {
        // Given
        Current.locale = Locale(identifier: "en-US")
        let expected = "en-US"

        // When
        let language = String.languageFormattedForTMDb

        // Then
        XCTAssertEqual(language, expected)
    }

}
