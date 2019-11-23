//
//  MovieNightUserCellSnapshotTests.swift
//  CineasteSnapshotTests
//
//  Created by Felizia Bernutz on 23.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Cineaste_App

class MovieNightUserCellSnapshotTests: XCTestCase {
    private let size = CGSize(width: 320, height: 100)

    var cell: MovieNightUserCell {
        let vc = MovieNightViewController.instantiate()
        let cell: MovieNightUserCell = vc.tableView.dequeueCell(identifier: MovieNightUserCell.identifier)
        cell.backgroundColor = .cineCellBackground
        return cell
    }

    func testAllFriendsAppearance() {
        let cellAll = cell
        cellAll.configureAll(numberOfMovies: 3, namesOfFriends: ["Simulator", "Dev", "Colleague"])
        assertThemedViewSnapshot(matching: cellAll)
    }

    func testSpecificFriendAppearance() {
        let cellSpecificFriend = cell
        cellSpecificFriend.configure(userName: "Simulator", numberOfMovies: 2)
        assertThemedViewSnapshot(matching: cellSpecificFriend)
    }
}
