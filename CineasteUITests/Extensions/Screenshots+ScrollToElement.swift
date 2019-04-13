//
//  Screenshots+ScrollToElement.swift
//  CineasteUITests
//
//  Created by Felizia Bernutz on 31.03.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import XCTest

// from here, slightly adapted:
// https://gist.github.com/ryanmeisters/f4e961731db289f489e1a08183e334d9

extension XCUIApplication {
    private enum Offset {
        static let top = CGVector(dx: 0.5, dy: 0.3)
        static let bottom = CGVector(dx: 0.5, dy: 0.7)
    }

    var screenTopCoordinate: XCUICoordinate {
        return windows.firstMatch
            .coordinate(withNormalizedOffset: Offset.top)
    }

    private var screenBottomCoordinate: XCUICoordinate {
        return windows.firstMatch
            .coordinate(withNormalizedOffset: Offset.bottom)
    }

    func scrollDownToElement(element: XCUIElement, maxScrolls: Int = 5) {
        for _ in 0..<maxScrolls {
            guard !element.isHittable else { return }
            scrollDown()
        }
    }

    func scrollDown() {
        screenBottomCoordinate
            .press(forDuration: 0.01, thenDragTo: screenTopCoordinate)
    }
}
