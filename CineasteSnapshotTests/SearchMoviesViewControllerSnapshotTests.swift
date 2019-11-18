//
//  SearchMoviesViewControllerSnapshotTests.swift
//  CineasteSnapshotTests
//
//  Created by Felizia Bernutz on 17.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import XCTest
import ReSwift
import SnapshotTesting
@testable import Cineaste_App

class SearchMoviesViewControllerSnapshotTests: XCTestCase {

    func testGeneralAppearance() {
        // Given
        let viewController = SearchMoviesViewController.instantiate()

        // When
        viewController.moviesFromNetworking = [
            .testing,
            .testingSeen,
            .testingWatchlist,
            .testingWatchlist2
        ]
        waitForQueue()

        // Then
        let navigationController = NavigationController(rootViewController: viewController)
        assertViewSnapshot(matching: navigationController)
    }

    func testAppearanceWithMarkedMovies() {
        // Given
        let viewController = SearchMoviesViewController.instantiate()

        // When
        var state = AppState()
        state.movies = [
            .testingSeen,
            .testingWatchlist,
            .testingWatchlist2
        ]
        store = Store(reducer: appReducer, state: state)

        viewController.moviesFromNetworking = [
            .testing,
            .testingSeen,
            .testingWatchlist,
            .testingWatchlist2
        ]
        waitForQueue()

        // Then
        let navigationController = NavigationController(rootViewController: viewController)
        assertViewSnapshot(matching: navigationController)
    }

    func testLoadingAppearance() {
        // Given
        let viewController = SearchMoviesViewController.instantiate()

        // Then
        let navigationController = NavigationController(rootViewController: viewController)
        assertViewSnapshot(matching: navigationController)
    }
}
