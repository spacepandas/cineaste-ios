//
//  WantToSeeMoviesSourceTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import XCTest
import CoreData
@testable import Cineaste

class WantToSeeMoviesSourceTests: XCTestCase {
    let source = WantToSeeMoviesSource()
    var tableView: UITableView!

    override func setUp() {
        super.setUp()
        let vc = WantToSeeMoviesViewController.instantiate()
        vc.loadViewIfNeeded()
        tableView = vc.myMoviesTableView
        tableView.dataSource = source
    }

    func testNumberOfRows() {
        XCTAssertEqual(source.tableView(tableView, numberOfRowsInSection: 0), 0)

        source.fetchedObjects = storedMovies

        XCTAssertEqual(source.tableView(tableView, numberOfRowsInSection: 0), 2)
    }

    func testCellForRow() {
        source.fetchedObjects = storedMovies
        tableView.dataSource = source
        for row in 0..<storedMovies.count {
            let path = IndexPath(row: row, section: 0)
            let cell = source.tableView(tableView, cellForRowAt: path)

            XCTAssert(cell is WantToSeeListCell)
        }
    }

    private let storedMovies: [StoredMovie] = {
        let managedObjectContext = setUpInMemoryManagedObjectContext()
        let entity = NSEntityDescription.insertNewObject(forEntityName: "StoredMovie", into: managedObjectContext) as! StoredMovie
        return [entity, entity]
    }()

}
