//
//  PosterViewControllerSnapshotTests.swift
//  CineasteSnapshotTests
//
//  Created by Felizia Bernutz on 28.12.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Cineaste_App

class PosterViewControllerSnapshotTests: XCTestCase {

    func testGeneralAppearance() {
        // Given
        let viewController = PosterViewController.instantiate()

        // Then
        assertThemedViewSnapshot(matching: viewController.view)
    }

}
