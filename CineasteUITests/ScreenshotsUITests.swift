//
//  ScreenshotsUITests.swift
//  ScreenshotsUITests
//
//  Created by Felizia Bernutz on 20.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import XCTest

class ScreenshotsUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        app.launchArguments += [
            "SKIP_ANIMATIONS",
            "UI_TEST"

            // Enable the following launch arguments
            // to test dynamic type without running `fastlane screenshot`
            // but when running UITests with Xcode.

            //            "-UIPreferredContentSizeCategoryName",
            //            "UICTContentSizeCategoryAccessibilityL"
            //            "-UIPreferredContentSizeCategoryName",
            //            "UICTContentSizeCategoryL"
        ]

        setupSnapshot(app, waitForAnimations: false)
        app.launch()

        resetMoviesIfNeeded()
    }

    func testScreenshots() {
        let backButton = app.navigationBars.buttons.element(boundBy: 0).firstMatch

        // Empty Watchlist
        XCTAssertEqual(app.cells.count, 0)

        XCTContext.runActivity(named: "Search for Movies without Markers") { _ in
            app.tabBars.buttons["SearchTab"].firstMatch.tap()

            // Check that search is not empty
            let firstCellInSearch = app.tables["Search.TableView"].cells.element(boundBy: 0).firstMatch
            let exists = NSPredicate(format: "exists == true")
            expectation(for: exists, evaluatedWith: firstCellInSearch, handler: nil)
            waitForExpectations(timeout: 2, handler: nil)
            XCTAssert(firstCellInSearch.exists)
        }

        XCTContext.runActivity(named: "Add first Movie to Watchlist from Search Movie Detail") { _ in
            markMovieFromSearch(index: 0, asWatched: false)
        }

        XCTContext.runActivity(named: "Mark second Movie as watched from Search Movie Detail") { _ in
            markMovieFromSearch(index: 1, asWatched: true)
        }

        XCTContext.runActivity(named: "Mark fourth Movie as watched from Search Movie Detail") { _ in
            markMovieFromSearch(index: 3, asWatched: true)
        }

        XCTContext.runActivity(named: "See Search with marked Movies") { _ in
            namedSnapshot("02_search")
        }

        XCTContext.runActivity(named: "See Watchlist") { _ in
            app.tabBars.buttons["WatchlistTab"].firstMatch.tap()
            XCTAssertEqual(app.cells.count, 1)
            namedSnapshot("03_watchlist")

            // Watchlist Detail
            let wantToSeeMovie = app.cells.element(boundBy: 0).firstMatch
            wantToSeeMovie.tap()
            namedSnapshot("01_watchlist_detail")
            backButton.tap()
        }

        XCTContext.runActivity(named: "See Seen List") { _ in
            app.tabBars.buttons["SeenTab"].firstMatch.tap()
            XCTAssertEqual(app.cells.count, 2)
            namedSnapshot("04_seenList")

            // History Detail
            let seenMovie = app.cells.element(boundBy: 0).firstMatch
            seenMovie.tap()
            backButton.tap()
        }

        XCTContext.runActivity(named: "See More Content") { _ in
            let settingsTab = app.tabBars.buttons["SettingsTab"].firstMatch
            settingsTab.tap()
            namedSnapshot("05_settings")

            let aboutTheApp = app.cells.element(boundBy: 0).firstMatch
            aboutTheApp.tap()
            backButton.tap()

            let license = app.cells.element(boundBy: 1).firstMatch
            license.tap()
        }
    }
}

extension ScreenshotsUITests {

    private func markMovieFromSearch(index movieIndex: Int, asWatched watched: Bool) {
        let movieInSearch = app.tables["Search.TableView"].cells.element(boundBy: movieIndex).firstMatch
        movieInSearch.tap()

        app.scrollDownToElement(element: app.segmentedControls.firstMatch)

        let segmentedControlIndex = watched ? 1 : 0
        app.segmentedControls.buttons.element(boundBy: segmentedControlIndex).firstMatch.tap()

        let backButton = app.navigationBars.buttons.element(boundBy: 0).firstMatch
        backButton.tap()
    }

    private func resetMoviesIfNeeded() {
        app.tabBars.buttons["SeenTab"].firstMatch.tap()
        deleteAllMoviesInListIfNeeded()

        app.tabBars.buttons["WatchlistTab"].firstMatch.tap()
        deleteAllMoviesInListIfNeeded()
    }

    private func deleteAllMoviesInListIfNeeded() {
        for _ in 0..<app.cells.count {
            app.cells.element(boundBy: 0).firstMatch.tap()
            app.toolbars.buttons.element(boundBy: 0).firstMatch.tap()
        }
        XCTAssertEqual(app.cells.count, 0)
    }

    private func namedSnapshot(_ name: String) {
        if app.launchArguments.contains("UICTContentSizeCategoryAccessibilityL") {
            snapshot(name + "_a11y", timeWaitingForIdle: 0)
        } else {
            snapshot(name, timeWaitingForIdle: 0)
        }
    }
}
