//
//  WatchlistMovieCellSnapshotTests.swift
//  CineasteSnapshotTests
//
//  Created by Felizia Bernutz on 22.08.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Cineaste_App

class WatchlistMovieCellSnapshotTests: XCTestCase {
    private let size = CGSize(width: 400, height: 200)

    func testGeneralAppearance() {
        let vc = MoviesViewController.instantiate()
        let cell: WatchlistMovieCell = vc.tableView.dequeueCell(identifier: WatchlistMovieCell.identifier)
        cell.configure(with: .testingWatchlistWithoutPosterPath)
        assertThemedViewSnapshot(matching: cell, with: size)
    }
}
