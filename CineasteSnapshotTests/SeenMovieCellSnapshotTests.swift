//
//  SeenMovieCellSnapshotTests.swift
//  CineasteSnapshotTests
//
//  Created by Felizia Bernutz on 22.08.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Cineaste_App

class SeenMovieCellSnapshotTests: XCTestCase {

    func testGeneralAppearance() {
        let vc = MoviesViewController.instantiate()
        let cell: SeenMovieCell = vc.tableView.dequeueCell(identifier: SeenMovieCell.identifier)
        cell.configure(with: .testingSeenWithoutPosterPath)
        assertThemedViewSnapshot(matching: cell)
    }
}
