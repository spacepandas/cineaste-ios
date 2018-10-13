//
//  SearchMoviesViewControllerTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import XCTest
@testable import Cineaste_App_Dev

class SearchMoviesViewControllerTests: XCTestCase {
    let searchMoviesVC = SearchMoviesViewController.instantiate()

    override func setUp() {
        super.setUp()

        self.searchMoviesVC.movies = []
        searchMoviesVC.tableView.reloadData()
    }

    func testTableViewDelegateAndDataSourceShouldNotBeNil() {
        searchMoviesVC.viewDidLoad()

        XCTAssertNotNil(searchMoviesVC.tableView.delegate)
        XCTAssertNotNil(searchMoviesVC.tableView.dataSource)
    }
    
    func testBackgroundColorShouldBeSetCorrectly() {
        searchMoviesVC.viewDidLoad()

        XCTAssertEqual(searchMoviesVC.view.backgroundColor, UIColor.basicBackground)
        XCTAssertEqual(searchMoviesVC.tableView.backgroundColor, UIColor.clear)
    }
    
    func testNumberOfRowsShouldEqualNumberOfMovies() {
        XCTAssertEqual(searchMoviesVC.tableView.numberOfRows(inSection: 0), 0)

        searchMoviesVC.movies = movies
        searchMoviesVC.tableView.reloadData()

        XCTAssertEqual(searchMoviesVC.tableView.numberOfRows(inSection: 0), 2)
    }

    func testCellForRowShouldBeOfTypeSearchMoviesCell() {
        searchMoviesVC.movies = movies
        searchMoviesVC.tableView.reloadData()

        for row in 0..<movies.count {
            let path = IndexPath(row: row, section: 0)
            let cell = searchMoviesVC.tableView.cellForRow(at: path)

            XCTAssert(cell is SearchMoviesCell)
        }
    }

    func testDequeueReusableCellWithSearchMoviesCellIdentifierShouldReturnTableViewCell() {
        let tableView = searchMoviesVC.tableView!

        // important:
        // use dequeueReusableCell:withIdentifier for this test, this method
        // returns nil, when the tableView can not dequeue a reusable cell,
        // with dequeueReusableCell:withIdentifier:indexPath it would simply
        // crash at this point
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchMoviesCell.identifier)
        XCTAssertNotNil(cell)

        let invalidCell = tableView.dequeueReusableCell(withIdentifier: "invalidIdentifier")
        XCTAssertNil(invalidCell)
    }

    private let movies: [Movie] = {
        guard let path = Bundle(for: SearchMoviesViewControllerTests.self).path(forResource: "Movie", ofType: "json") else {
            fatalError("Could not load file for resource Movie.json")
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            let movie = try! JSONDecoder().decode(Movie.self, from: data)
            return [movie, movie]
        } catch let error {
            fatalError("Error while decoding Movie.json: \(error.localizedDescription)")
        }
    }()

}
