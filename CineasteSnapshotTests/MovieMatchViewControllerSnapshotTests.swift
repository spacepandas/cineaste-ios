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
            NearbyMovie(id: 1, title: "Film B", posterPath: nil),
            NearbyMovie(id: 2, title: "Asterix", posterPath: nil),
            NearbyMovie(id: 3, title: "Film 3", posterPath: nil)
        ]
        let developerMovies = [
            NearbyMovie(id: 1, title: "Film B", posterPath: nil),
            NearbyMovie(id: 2, title: "Asterix", posterPath: nil)
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
