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
    private let size = CGSize(width: 320, height: 100)

    var cell: SearchMoviesCell {
        let vc = SearchMoviesViewController.instantiate()
        let cell: SearchMoviesCell = vc.tableView.dequeueCell(identifier: SearchMoviesCell.identifier)
        return cell
    }

    func testUndefinedAppearance() {
        let cellUndefined = cell
        cellUndefined.configure(with: Movie.testing, state: .undefined)
        assertThemedViewSnapshot(matching: cellUndefined, with: size)
    }

    func testWatchlistAppearance() {
        let cellWatchlist = cell
        cellWatchlist.configure(with: Movie.testingWatchlist, state: .watchlist)
        assertThemedViewSnapshot(matching: cellWatchlist, with: size)
    }

    func testWatchlistComingSoonAppearance() {
        let cellWatchlist = cell
        cellWatchlist.configure(with: Movie.testingWatchlist2, state: .watchlist)
        assertThemedViewSnapshot(matching: cellWatchlist, with: size)
    }

    func testSeenAppearance() {
        let cellSeen = cell
        cellSeen.configure(with: Movie.testingSeen, state: .seen)
        assertThemedViewSnapshot(matching: cellSeen, with: size)
    }

}
