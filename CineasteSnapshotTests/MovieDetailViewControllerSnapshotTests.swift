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
        let viewController = MovieDetailViewController.instantiate()

        // When
        var state = AppState()
        let movie = Movie.testingWithoutPosterPath
        state.movies = [movie]
        state.selectedMovieId = movie.id
        store = Store(reducer: appReducer, state: state)

        // Then
        let navigationController = NavigationController(rootViewController: viewController)
        assertThemedNavigationSnapshot(matching: navigationController)
    }

    func testWatchlistMovieAppearance() {
        // Given
        let viewController = MovieDetailViewController.instantiate()

        // When
        var state = AppState()
        let movie = Movie.testingWatchlistWithoutPosterPath
        state.movies = [movie]
        state.selectedMovieId = movie.id
        store = Store(reducer: appReducer, state: state)

        // Then
        let navigationController = NavigationController(rootViewController: viewController)
        assertThemedNavigationSnapshot(matching: navigationController)
    }
}
