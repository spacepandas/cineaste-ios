//
//  SearchMoviesSourceTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import XCTest
@testable import Cineaste

class SearchMoviesSourceTests: XCTestCase {
    let source = SearchMoviesSource()
    var tableView: UITableView!

    override func setUp() {
        super.setUp()
        let vc = SearchMoviesViewController.instantiate()
        vc.loadViewIfNeeded()
        tableView = vc.moviesTableView
        tableView.dataSource = source
    }

    func testNumberOfRows() {
        XCTAssertEqual(source.tableView(tableView, numberOfRowsInSection: 0), 0)

        source.movies = movies

        XCTAssertEqual(source.tableView(tableView, numberOfRowsInSection: 0), 2)
    }

    func testCellForRow() {
        source.movies = movies
        tableView.dataSource = source
        for row in 0..<movies.count {
            let path = IndexPath(row: row, section: 0)
            let cell = source.tableView(tableView, cellForRowAt: path)

            XCTAssert(cell is SearchMoviesCell)
        }
    }

    private let movies: [Movie] = {
        guard let path = Bundle(for: SearchMoviesSourceTests.self).path(forResource: "Movie", ofType: "json") else {
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
