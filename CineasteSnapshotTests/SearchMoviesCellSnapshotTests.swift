//
//  SearchMoviesCellSnapshotTests.swift
//  CineasteSnapshotTests
//
//  Created by Felizia Bernutz on 18.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Cineaste_App

class SearchMoviesCellSnapshotTests: XCTestCase {
    var cell: SearchMoviesCell {
        let vc = SearchMoviesViewController.instantiate()
        let cell: SearchMoviesCell = vc.tableView.dequeueCell(identifier: SearchMoviesCell.identifier)
        return cell
    }

    func testUndefinedAppearance() {
        let cellUndefined = cell
        cellUndefined.configure(with: Movie.testingWithoutPosterPath)
        assertThemedViewSnapshot(matching: cellUndefined)
    }

    func testWatchlistAppearance() {
        let cellWatchlist = cell
        cellWatchlist.configure(with: Movie.testingWatchlistWithoutPosterPath)
        assertThemedViewSnapshot(matching: cellWatchlist)
    }

    func testWatchlistComingSoonAppearance() {
        let cellWatchlist = cell
        cellWatchlist.configure(with: Movie.testingWatchlist2WithoutPosterPath)
        assertThemedViewSnapshot(matching: cellWatchlist)
    }

    func testSeenAppearance() {
        let cellSeen = cell
        cellSeen.configure(with: Movie.testingSeenWithoutPosterPath)
        assertThemedViewSnapshot(matching: cellSeen)
    }

}
