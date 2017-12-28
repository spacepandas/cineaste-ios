//
//  SeenMoviesViewControllerTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import XCTest
@testable import Cineaste

class SeenMoviesViewControllerTests: XCTestCase {
    let seenMoviesVC = SeenMoviesViewController.instantiate()

    func testViewDidLoad() {
        seenMoviesVC.viewDidLoad()

        XCTAssertNotNil(seenMoviesVC.fetchedResultsManager.delegate)
    }

}
