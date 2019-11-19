//
//  MoviesViewControllerTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 01.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import XCTest
@testable import Cineaste_App

class MoviesViewControllerTests: XCTestCase {
    let moviesVC = MoviesViewController.instantiate()
    var tableView: UITableView!

    override func setUp() {
        super.setUp()

        tableView = moviesVC.tableView
        tableView.dataSource = moviesVC
    }

    func testDequeueReusableCellWithMovieListCellIdentifierShouldReturnTableViewCell() {
        // important:
        // use dequeueReusableCell:withIdentifier for this test, this method
        // returns nil, when the tableView can not dequeue a reusable cell,
        // with dequeueReusableCell:withIdentifier:indexPath it would simply
        // crash at this point
        let cell = tableView.dequeueReusableCell(withIdentifier: WatchlistMovieCell.identifier)
        XCTAssertNotNil(cell)

        let invalidCell = tableView.dequeueReusableCell(withIdentifier: "invalidIdentifier")
        XCTAssertNil(invalidCell)
    }

    func testDequeueReusableCellWithSeenMovieCellIdentifierShouldReturnTableViewCell() {
        // important:
        // use dequeueReusableCell:withIdentifier for this test, this method
        // returns nil, when the tableView can not dequeue a reusable cell,
        // with dequeueReusableCell:withIdentifier:indexPath it would simply
        // crash at this point
        let cell = tableView.dequeueReusableCell(withIdentifier: SeenMovieCell.identifier)
        XCTAssertNotNil(cell)

        let invalidCell = tableView.dequeueReusableCell(withIdentifier: "invalidIdentifier")
        XCTAssertNil(invalidCell)
    }
}
