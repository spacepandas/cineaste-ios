//
//  MoviesViewControllerSnapshotTests.swift
//  CineasteSnapshotTests
//
//  Created by Felizia Bernutz on 17.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import XCTest
import SnapshotTesting
import ReSwift
@testable import Cineaste_App

class MoviesViewControllerSnapshotTests: XCTestCase {

    func testEmptyAppearance() {
        // Given
        let viewController = MoviesViewController.instantiate()
        let navigationController = NavigationController(rootViewController: viewController)

        // When
        viewController.category = .watchlist

        // Then
        assertThemedNavigationSnapshot(matching: navigationController)
    }

    // issue reported: https://github.com/spacepandas/cineaste-ios/issues/124
    func disabledtestGeneralAppearanceForWatchlist() {
        // Given
        let viewController = MoviesViewController.instantiate()
        let navigationController = NavigationController(rootViewController: viewController)

        // When
        viewController.category = .watchlist

        var state = AppState()
        state.movies = [
            Movie.testingWatchlistWithoutPosterPath,
            Movie.testingWatchlist2WithoutPosterPath
        ]
        store = Store(reducer: appReducer, state: state)

        // Then
        assertThemedNavigationSnapshot(matching: navigationController)
    }

    // issue reported: https://github.com/spacepandas/cineaste-ios/issues/124
    func disabledtestGeneralAppearanceForHistory() {
        // Given
        let viewController = MoviesViewController.instantiate()
        let navigationController = NavigationController(rootViewController: viewController)

        // When
        viewController.category = .seen

        var state = AppState()
        state.movies = [
            Movie.testingSeenWithoutPosterPath
        ]
        store = Store(reducer: appReducer, state: state)

        // Then
        assertThemedNavigationSnapshot(matching: navigationController)
    }
}
