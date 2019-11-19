//
//  MovieNightViewControllerSnapshotTests.swift
//  CineasteSnapshotTests
//
//  Created by Felizia Bernutz on 18.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Cineaste_App

class MovieNightViewControllerSnapshotTests: XCTestCase {

    override class func setUp() {
        super.setUp()

        UsernamePersistence.username = "Simulator"
    }

    func testGeneralAppearance() {
        // Given
        let viewController = MovieNightViewController.instantiate()

        // When
        viewController.canUseNearby = true
        viewController.toggleSearchingForFriendsMode()

        // Then
        let navigationController = NavigationController(rootViewController: viewController)
        assertThemedNavigationSnapshot(matching: navigationController)
    }

    func testPermissionGrantedAppearance() {
        // Given
        let viewController = MovieNightViewController.instantiate()

        // When
        viewController.canUseNearby = true

        // Then
        let navigationController = NavigationController(rootViewController: viewController)
        assertThemedNavigationSnapshot(matching: navigationController)
    }

    func testPermissionDeniedAppearance() {
        // Given
        let viewController = MovieNightViewController.instantiate()

        // When
        viewController.canUseNearby = false

        // Then
        let navigationController = NavigationController(rootViewController: viewController)
        assertThemedNavigationSnapshot(matching: navigationController)
    }
}
