//
//  MoviesTabBarControllerSnapshotTests.swift
//  CineasteSnapshotTests
//
//  Created by Felizia Bernutz on 17.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import XCTest
import ReSwift
import SnapshotTesting
@testable import Cineaste_App

class MoviesTabBarControllerSnapshotTests: XCTestCase {

    func testGeneralHierarchy() {
        // Given
        let tabBar = MoviesTabBarController.instantiate()

        // Then
        assertSnapshot(matching: tabBar, as: .hierarchy)
    }

}
