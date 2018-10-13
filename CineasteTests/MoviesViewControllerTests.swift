//
//  MoviesViewControllerTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 01.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import XCTest
import CoreData
@testable import Cineaste_App_Dev

class MoviesViewControllerTests: XCTestCase {
    let moviesVC = MoviesViewController.instantiate()
    var tableView: UITableView!

    override func setUp() {
        super.setUp()
        tableView = moviesVC.tableView
        tableView.dataSource = moviesVC
    }

    func testFetchedResultsManagerDelegateIsNotNil() {
        moviesVC.viewDidLoad()
        XCTAssertNotNil(moviesVC.fetchedResultsManager.delegate)
    }

    func testSettingCategoryShouldChangeTitleOfVC() {
        let seenTitle = MovieListCategory.seen.title
        moviesVC.category = .seen
        XCTAssertEqual(moviesVC.title, seenTitle)

        let wantToSeeTitle = MovieListCategory.watchlist.title
        moviesVC.category = .watchlist
        XCTAssertEqual(moviesVC.title, wantToSeeTitle)
    }

    func testEmptyListShouldHideTableView() {
        XCTAssertNotNil(tableView.backgroundView)

        moviesVC.showEmptyState(true) {
            XCTAssertFalse(self.tableView.backgroundView!.isHidden)
        }

        moviesVC.showEmptyState(false) {
            XCTAssertTrue(self.tableView.backgroundView!.isHidden)
        }
    }

    func testNumberOfRowsShouldEqualNumberOfFetchedObjects() {
        if moviesVC.fetchedResultsManager.movies.isEmpty {
            XCTAssertEqual(tableView.numberOfRows(inSection: 0), 0)
        } else {
            XCTAssertEqual(tableView.numberOfRows(inSection: 0), moviesVC.fetchedResultsManager.movies.count)
        }
    }

    func testDequeueReusableCellWithMovieListCellIdentifierShouldReturnTableViewCell() {
        // important:
        // use dequeueReusableCell:withIdentifier for this test, this method
        // returns nil, when the tableView can not dequeue a reusable cell,
        // with dequeueReusableCell:withIdentifier:indexPath it would simply
        // crash at this point
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieListCell.identifier)
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

    private let storedMovie: StoredMovie = {
        let managedObjectContext = setUpInMemoryManagedObjectContext()
        let entity = NSEntityDescription.insertNewObject(forEntityName: "StoredMovie", into: managedObjectContext) as! StoredMovie
        return entity
    }()
}
