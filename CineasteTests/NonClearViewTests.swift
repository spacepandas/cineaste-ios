//
//  NonClearViewTests.swift
//  CineasteTests
//
//  Created by Xaver Lohmüller on 19.08.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import XCTest
@testable import Cineaste_App

class NonClearViewTests: XCTestCase {

    func testNonClearViewShouldNotAcceptClearColor() {
        // Given
        let view = SeparatorView()
        let initialColor = UIColor.red
        view.backgroundColor = initialColor

        // When
        view.backgroundColor = .clear

        // Then
        XCTAssertEqual(view.backgroundColor, initialColor)
    }

    func testNonClearViewShouldAcceptColorsAboveZeroAlpha() {
        // Given
        let view = SeparatorView()
        let notTotallyTransparentColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)

        // When
        view.backgroundColor = notTotallyTransparentColor

        // Then
        XCTAssertEqual(view.backgroundColor, notTotallyTransparentColor)
    }
}
