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

    func testLoadingAppearance() throws {
        // Given
        var state = AppState()
        let url = try XCTUnwrap(URL(string: "test"))
        let task = URLSession(configuration: .default).dataTask(with: url)
        state.searchState.currentRequest = task
        store = Store(reducer: appReducer, state: state)
        let viewController = SearchMoviesViewController.instantiate()

        // Then
        let navigationController = NavigationController(rootViewController: viewController)
        assertThemedNavigationSnapshot(matching: navigationController)
    }
}
