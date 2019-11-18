//
//  MovieMatchViewControllerSnapshotTests.swift
//  CineasteSnapshotTests
//
//  Created by Felizia Bernutz on 18.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Cineaste_App

class MovieMatchViewControllerSnapshotTests: XCTestCase {

    func testGeneralAppearance() {
        // Given
        let viewController = MovieMatchViewController.instantiate()

        let simulatorMovies = [
            NearbyMovie.testing1,
            NearbyMovie.testing2,
            NearbyMovie.testing3
        ]
        let developerMovies = [
            NearbyMovie.testing1,
            NearbyMovie.testing2
        ]

        let nearbyMessages = [
            NearbyMessage(userName: "Simulator", deviceId: "1", movies: simulatorMovies),
            NearbyMessage(userName: "Developer", deviceId: "2", movies: developerMovies)
        ]

        // When
        viewController.configure(with: "Simulator", messagesToMatch: nearbyMessages)

        // Then
        let navigationController = NavigationController(rootViewController: viewController)
        assertViewSnapshot(matching: navigationController)
    }
}
