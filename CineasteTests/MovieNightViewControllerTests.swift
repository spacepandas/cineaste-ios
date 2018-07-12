//
//  MovieNightViewControllerTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 19.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import XCTest
@testable import Cineaste_App_Dev

class MovieNightViewControllerTests: XCTestCase {
    let movieNightVC = MovieNightViewController.instantiate()

    func testBackgroundColorShouldEqualBasicBlackground() {
        XCTAssertEqual(movieNightVC.view.backgroundColor, UIColor.basicBackground)
    }
}
