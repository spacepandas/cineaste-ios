//
//  MoviesViewControllerTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 01.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import XCTest
import CoreData
@testable import Cineaste_App

class MoviesViewControllerTests: XCTestCase {
    let moviesVC = MoviesViewController.instantiate()
    var tableView: UITableView!

    override func setUp() {
        super.setUp()

        tableView = moviesVC.tableView
        tableView.dataSource = moviesVC
    }

    func testSettingCategoryShouldChangeTitleOfVC() {
        let seenTitle = MovieListCategory.seen.title
        moviesVC.category = .seen
        XCTAssertEqual(moviesVC.title, seenTitle)

        let wantToSeeTitle = MovieListCategory.watchlist.title
        moviesVC.category = .watchlist
        XCTAssertEqual(moviesVC.title, wantToSeeTitle)
    }

    func testTableViewShouldHideWhenListIsEmpty() {
        XCTAssertNotNil(tableView.backgroundView)
        let exp = expectation(description: "\(#function)\(#line)")

        moviesVC.showEmptyState(true) {
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
        XCTAssertFalse(tableView.backgroundView!.isHidden)
    }

    func testTableViewShouldNotHideWhenListIsNotEmpty() {
        XCTAssertNotNil(tableView.backgroundView)
        let exp = expectation(description: "\(#function)\(#line)")

        moviesVC.showEmptyState(false) {
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
        XCTAssertTrue(tableView.backgroundView!.isHidden)
    }

    func testNumberOfRowsShouldEqualNumberOfFetchedObjects() {
        if moviesVC.movies.isEmpty {
            XCTAssertEqual(tableView.numberOfRows(inSection: 0), 0)
        } else {
            XCTAssertEqual(tableView.numberOfRows(inSection: 0), moviesVC.movies.count)
        }
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
