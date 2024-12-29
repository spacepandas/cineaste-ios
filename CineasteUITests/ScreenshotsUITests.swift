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
    }

    @MainActor
    func testScreenshots() {
        setupSnapshot(app, waitForAnimations: true)
        app.launch()

        resetMoviesIfNeeded()

        let backButton = app.navigationBars.buttons.element(boundBy: 0).firstMatch

        screenshotSearchWithMarkers()

        XCTContext.runActivity(named: "See Watchlist") { _ in
            app.tabBars.buttons["WatchlistTab"].firstMatch.tap()
            XCTAssertNotEqual(app.cells.count, 0)
            namedSnapshot("03_watchlist")
        }

        XCTContext.runActivity(named: "See Watchlist iPhone Landscape") { _ in
            if UIDevice.current.userInterfaceIdiom == .phone {
                XCUIDevice.shared.orientation = .landscapeLeft

                namedSnapshot("03_watchlist_landscape")

                XCUIDevice.shared.orientation = .portrait
            }
        }

        XCTContext.runActivity(named: "See Watchlist Detail") { _ in
            let wantToSeeMovie = app.cells.element(boundBy: 0).firstMatch
            wantToSeeMovie.tap()

            namedSnapshot("01_watchlist_detail")
        }

        XCTContext.runActivity(named: "See Watchlist Detail iPad Landscape") { _ in
            if UIDevice.current.userInterfaceIdiom == .pad {
                XCUIDevice.shared.orientation = .landscapeLeft

                app.scrollDownToElement(element: app.segmentedControls.firstMatch)
                app.scrollDown()

                namedSnapshot("01_watchlist_detail_landscape")

                XCUIDevice.shared.orientation = .portrait
            }

            backButton.tap()
        }

        XCTContext.runActivity(named: "See Seen List") { _ in
            app.tabBars.buttons["SeenTab"].firstMatch.tap()
            XCTAssertNotEqual(app.cells.count, 0)
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

    @MainActor
    func testScreenshotsOfSearchWithDarkMode() {
        app.launchArguments += [
            "UI_TEST_DARK_MODE"
        ]
        setupSnapshot(app, waitForAnimations: true)
        app.launch()

        screenshotSearchWithMarkers()
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

    private func screenshotSearchWithMarkers() {
        XCTContext.runActivity(named: "Search for Movies without Markers") { _ in
            app.tabBars.buttons["SearchTab"].firstMatch.tap()

            // Check that search is not empty
            let firstCellInSearch = app.tables["Search.TableView"].cells.element(boundBy: 0).firstMatch
            let exists = NSPredicate(format: "exists == true")
            expectation(for: exists, evaluatedWith: firstCellInSearch, handler: nil)
            waitForExpectations(timeout: 2, handler: nil)
            XCTAssert(firstCellInSearch.exists)
        }

        XCTContext.runActivity(named: "Add sixth Movie to Watchlist from Search Movie Detail") { _ in
            markMovieFromSearch(index: 5, asWatched: false)
        }

        XCTContext.runActivity(named: "Mark second Movie as watched from Search Movie Detail") { _ in
            markMovieFromSearch(index: 1, asWatched: true)
        }

        XCTContext.runActivity(named: "Mark fourth Movie as watched from Search Movie Detail") { _ in
            markMovieFromSearch(index: 3, asWatched: true)
        }

        XCTContext.runActivity(named: "Add first Movie to Watchlist from Search Movie Detail") { _ in
            markMovieFromSearch(index: 0, asWatched: false)
        }

        XCTContext.runActivity(named: "See Search with marked Movies") { _ in
            namedSnapshot("02_search")
        }
    }

    @MainActor private func namedSnapshot(_ name: String) {
        snapshot(snapshotName(for: name), timeWaitingForIdle: 0)
    }

    private func snapshotName(for name: String) -> String {
        var snapshotName = name

        if app.launchArguments.contains("UICTContentSizeCategoryAccessibilityL") {
            snapshotName += "_a11y"
        }

        if app.launchArguments.contains("UI_TEST_DARK_MODE") {
            snapshotName += "_dark"
        }
        return snapshotName
    }
}
