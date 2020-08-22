//
//  MovieDetailViewControllerSnapshotTests.swift
//  CineasteSnapshotTests
//
//  Created by Felizia Bernutz on 08.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import XCTest
import ReSwift
import SnapshotTesting
@testable import Cineaste_App

class MovieDetailViewControllerSnapshotTests: XCTestCase {

    func testGeneralAppearance() {
        // Given
        var state = AppState()
        let movie = Movie.testingWithoutPosterPath
        state.movies = [movie]
        state.selectedMovieState.movie = movie
        store = Store(reducer: appReducer, state: state)

        // When
        let viewController = MovieDetailViewController.instantiate()

        // Then
        let navigationController = NavigationController(rootViewController: viewController)
        assertThemedNavigationSnapshot(matching: navigationController)
    }

    func testWatchlistMovieAppearance() {
        // Given
        var state = AppState()
        let movie = Movie.testingWatchlistWithoutPosterPath
        state.movies = [movie]
        state.selectedMovieState.movie = movie
        store = Store(reducer: appReducer, state: state)

        // When
        let viewController = MovieDetailViewController.instantiate()

        // Then
        let navigationController = NavigationController(rootViewController: viewController)
        assertThemedNavigationSnapshot(matching: navigationController)
    }
}
