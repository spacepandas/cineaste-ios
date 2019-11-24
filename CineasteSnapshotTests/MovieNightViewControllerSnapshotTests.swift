//
//  MovieNightViewControllerSnapshotTests.swift
//  CineasteSnapshotTests
//
//  Created by Felizia Bernutz on 18.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import XCTest
import ReSwift
import SnapshotTesting
@testable import Cineaste_App

class MovieNightViewControllerSnapshotTests: XCTestCase {

    override class func setUp() {
        super.setUp()

        UserDefaults.standard.username = "Simulator"
    }

    func testGeneralAppearance() {
        // Given
        let viewController = MovieNightViewController.instantiate()
        let simulatorMovies = [
            NearbyMovie.testing1,
            NearbyMovie.testing2,
            NearbyMovie.testing3
        ]
        let developerMovies = [
            NearbyMovie.testing1,
            NearbyMovie.testing2
        ]

        // When
        viewController.canUseNearby = true

        var state = AppState()
        state.nearbyState.nearbyMessages = [
            NearbyMessage(userName: "Simulator", deviceId: "1", movies: simulatorMovies),
            NearbyMessage(userName: "Developer", deviceId: "2", movies: developerMovies)
        ]
        store = Store(reducer: appReducer, state: state)

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
