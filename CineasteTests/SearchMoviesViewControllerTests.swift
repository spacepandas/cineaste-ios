//
//  SearchMoviesViewControllerTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import XCTest
@testable import Cineaste

class SearchMoviesViewControllerTests: XCTestCase {
    let searchMoviesVC = SearchMoviesViewController.instantiate()

    func testTableViewDelegateAndDataSourceShouldNotBeNil() {
        searchMoviesVC.viewDidLoad()

        XCTAssertNotNil(searchMoviesVC.moviesTableView.delegate)
        XCTAssertNotNil(searchMoviesVC.moviesTableView.dataSource)
    }

}
