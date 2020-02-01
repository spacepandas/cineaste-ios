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
        XCTAssertEqual(app.cells.count, 0)
        namedSnapshot("emptyWatchlist")

        let backButton = app.navigationBars.buttons.element(boundBy: 0).firstMatch

        XCTContext.runActivity(named: "Search for Movies") { _ in
            app.tabBars.buttons["SearchTab"].firstMatch.tap()

            let firstCellInSearch = app.tables["Search.TableView"].cells.element(boundBy: 0).firstMatch
            let exists = NSPredicate(format: "exists == true")
            expectation(for: exists, evaluatedWith: firstCellInSearch, handler: nil)
            waitForExpectations(timeout: 2, handler: nil)
            XCTAssert(firstCellInSearch.exists)

            namedSnapshot("search_withoutMarker")
        }

        XCTContext.runActivity(named: "Add first Movie to Watchlist") { _ in
            let firstCellInSearch = app.tables["Search.TableView"].cells.element(boundBy: 0).firstMatch
            firstCellInSearch.tap()
            sleep(1)
            namedSnapshot("search_detail")

            app.scrollDownToElement(element: app.segmentedControls.firstMatch)
            app.segmentedControls.buttons.element(boundBy: 0).firstMatch.tap()
            backButton.tap()
        }

        XCTContext.runActivity(named: "Mark third Movie as watched") { _ in
            app.tables["Search.TableView"].cells.element(boundBy: 1).firstMatch.tap()
            app.scrollDownToElement(element: app.segmentedControls.firstMatch)
            app.segmentedControls.buttons.element(boundBy: 1).firstMatch.tap()
            backButton.tap()
        }

        XCTContext.runActivity(named: "Mark fourth Movie as watched") { _ in
            app.tables["Search.TableView"].cells.element(boundBy: 3).firstMatch.tap()
            app.scrollDownToElement(element: app.segmentedControls.firstMatch)
            app.segmentedControls.buttons.element(boundBy: 1).firstMatch.tap()
            backButton.tap()
        }

        XCTContext.runActivity(named: "See Search with marked Movies") { _ in
            namedSnapshot("02_search")
        }

        XCTContext.runActivity(named: "See Watchlist") { _ in
            app.tabBars.buttons["WatchlistTab"].firstMatch.tap()
            XCTAssertEqual(app.cells.count, 1)
            namedSnapshot("03_watchlist")

            let wantToSeeMovie = app.cells.element(boundBy: 0).firstMatch
            wantToSeeMovie.tap()
            sleep(1)
            namedSnapshot("01_watchlist_detail")
            backButton.tap()
        }

        XCTContext.runActivity(named: "See Seen List") { _ in
            app.tabBars.buttons["SeenTab"].firstMatch.tap()
            XCTAssertEqual(app.cells.count, 2)
            namedSnapshot("04_seenList")

            let seenMovie = app.cells.element(boundBy: 0).firstMatch
            seenMovie.tap()
            sleep(1)
            namedSnapshot("seen_detail")
            backButton.tap()
        }

        XCTContext.runActivity(named: "See More Content") { _ in
            let settingsTab = app.tabBars.buttons["SettingsTab"].firstMatch
            settingsTab.tap()
            namedSnapshot("06_settings")

            let aboutTheApp = app.cells.element(boundBy: 0).firstMatch
            aboutTheApp.tap()
            namedSnapshot("settings_aboutTheApp")

            backButton.tap()
            let license = app.cells.element(boundBy: 1).firstMatch
            license.tap()
            namedSnapshot("settings_license")
        }
    }
}

extension ScreenshotsUITests {
    private func resetMoviesIfNeeded() {
        let back = app.navigationBars.buttons.element(boundBy: 0).firstMatch

        app.tabBars.buttons["SeenTab"].firstMatch.tap()
        for _ in 0..<app.cells.count {
            app.cells.element(boundBy: 0).firstMatch.tap()
            app.toolbars.buttons.element(boundBy: 0).firstMatch.tap()
            back.tap()
        }
        XCTAssertEqual(app.cells.count, 0)

        app.tabBars.buttons["WatchlistTab"].firstMatch.tap()
        for _ in 0..<app.cells.count {
            app.cells.element(boundBy: 0).firstMatch.tap()
            app.toolbars.buttons.element(boundBy: 0).firstMatch.tap()
            back.tap()
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
