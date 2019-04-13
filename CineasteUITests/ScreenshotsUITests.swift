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

        if let domain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
        }

        app.launchArguments += [
            "SKIP_ANIMATIONS"

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
        namedSnapshot("emptyList")

        // MARK: Search
        let addMovieButton = app.navigationBars.buttons.element(boundBy: 1)
            .firstMatch
        addMovieButton.tap()
        _ = app.cells.element(boundBy: 0).waitForExistence(timeout: 1.0)
        namedSnapshot("search_without_marker")

        // Add first movie to watchlist
        app.cells.element(boundBy: 0).firstMatch.tap()
        namedSnapshot("search_detail")

        let wantToSeeButton = app.segmentedControls.buttons.element(boundBy: 0)
            .firstMatch
        app.scrollDownToElement(element: app.segmentedControls.firstMatch)
        wantToSeeButton.tap()

        let back = app.navigationBars.buttons.element(boundBy: 0).firstMatch
        back.tap()

        // Mark third movie as watched
        app.cells.element(boundBy: 1).firstMatch.tap()
        let seenButton = app.segmentedControls.buttons.element(boundBy: 1)
            .firstMatch
        app.scrollDownToElement(element: app.segmentedControls.firstMatch)
        seenButton.tap()
        back.tap()

        // Mark fourth movie as watched
        app.cells.element(boundBy: 3).firstMatch.tap()
        app.scrollDownToElement(element: app.segmentedControls.firstMatch)
        seenButton.tap()
        back.tap()

        namedSnapshot("02_search")
        back.tap()

        // MARK: Watchlist
        XCTAssertEqual(app.cells.count, 1)
        namedSnapshot("03_watchlist")

        let wantToSeeMovie = app.cells.element(boundBy: 0).firstMatch
        wantToSeeMovie.tap()
        namedSnapshot("01_watchlist_detail")
        back.tap()

        // MARK: Seen
        let seenTab = app.buttons["SeenTab"].firstMatch
        seenTab.tap()
        XCTAssertEqual(app.cells.count, 2)
        namedSnapshot("04_seenList")

        let seenMovie = app.cells.element(boundBy: 0).firstMatch
        seenMovie.tap()
        namedSnapshot("seen_detail")

        back.tap()

        // MARK: Movie Night
        let startMovieNightButton = app.navigationBars.buttons
            .element(boundBy: 0).firstMatch
        startMovieNightButton.tap()

        let usernameAlert = app.alerts.element(boundBy: 0)
        if usernameAlert.exists {
            namedSnapshot("startMovieNight_usernameAlert")
            let textField = usernameAlert.textFields.element(boundBy: 0)
                .firstMatch
            textField.tap()
            textField.typeText("Screenshots")
            let saveButton = usernameAlert.buttons.element(boundBy: 1)
                .firstMatch
            saveButton.tap()
        }

        let nearbyAlert = app.alerts.element(boundBy: 0)
        if nearbyAlert.exists {
            namedSnapshot("startMovieNight_nearbyAlert")
            let moreInfoButton = nearbyAlert.buttons.element(boundBy: 0)
                .firstMatch
            moreInfoButton.tap()
            namedSnapshot("startMovieNight_nearbyAlert_moreInfo")
            let allowNearbyButton = app.buttons.element(boundBy: 1).firstMatch
            allowNearbyButton.tap()
        }
        namedSnapshot("startMovieNight_searching")

        //use DEBUG triple tap to test nearby feature
        app.tap()
        app.tap()
        app.tap()

        namedSnapshot("05_startMovieNight_friendsFound")

        let startButton = app.buttons.element(boundBy: 1).firstMatch
        startButton.tap()
        namedSnapshot("startMovieNight_results")

        back.tap()
        back.tap()

        // MARK: Settings
        let settingsTab = app.buttons["SettingsTab"].firstMatch
        settingsTab.tap()
        namedSnapshot("06_settings")

        let aboutTheApp = app.cells.element(boundBy: 0).firstMatch
        aboutTheApp.tap()
        namedSnapshot("settings_aboutTheApp")

        back.tap()
        let license = app.cells.element(boundBy: 1).firstMatch
        license.tap()
        namedSnapshot("settings_license")
    }

    private func resetMoviesIfNeeded() {
        let back = app.navigationBars.buttons.element(boundBy: 0).firstMatch

        app.buttons["SeenTab"].firstMatch.tap()
        for _ in 0..<app.cells.count {
            app.cells.element(boundBy: 0).firstMatch.tap()
            app.toolbars.buttons.element(boundBy: 0).firstMatch.tap()
            back.tap()
        }
        XCTAssertEqual(app.cells.count, 0)

        app.buttons["WatchlistTab"].firstMatch.tap()
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
