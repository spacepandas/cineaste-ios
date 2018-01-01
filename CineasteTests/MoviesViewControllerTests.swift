//
//  MoviesViewControllerTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 01.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import XCTest
import CoreData
@testable import Cineaste

class MoviesViewControllerTests: XCTestCase {
    let moviesVC = MoviesViewController.instantiate()
    var tableView: UITableView!

    override func setUp() {
        super.setUp()
        tableView = moviesVC.myMoviesTableView
        tableView.dataSource = moviesVC
    }

    func testFetchedResultsManagerDelegateIsNotNil() {
        moviesVC.category = .wantToSee
        XCTAssertNotNil(moviesVC.fetchedResultsManager.delegate)
    }

//    func testNumberOfRowsShouldEqualNumberOfStoredMovies() {
//        XCTAssertEqual(moviesVC.tableView(tableView, numberOfRowsInSection: 0), 0)
//
//        moviesVC.fetchedResultsManager.controller?.fetchedObjects = storedMovies
//
//        XCTAssertEqual(moviesVC.tableView(tableView, numberOfRowsInSection: 0), 2)
//    }

//    func testCellForRowShouldBeOfTypeWantToSeeListCell() {
//        moviesVC.fetchedResultsManager.controller?.fetchedObjects = storedMovies
//
//        for row in 0..<storedMovies.count {
//            let path = IndexPath(row: row, section: 0)
//            let cell = moviesVC.tableView(tableView, cellForRowAt: path)
//
//            XCTAssert(cell is WantToSeeListCell)
//        }
//    }

    private let storedMovies: [StoredMovie] = {
        let managedObjectContext = setUpInMemoryManagedObjectContext()
        let entity = NSEntityDescription.insertNewObject(forEntityName: "StoredMovie", into: managedObjectContext) as! StoredMovie
        return [entity, entity]
    }()
    
}
