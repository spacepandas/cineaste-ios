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

        if let domain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
        }

        setupSnapshot(app)
        app.launch()

        resetMoviesIfNeeded()
    }

    override func tearDown() {
        resetMoviesIfNeeded()

        super.tearDown()
    }

    func testScreenshots() {
        XCTAssertEqual(app.cells.count, 0)
        snapshot("emptyList")

        let addMovieButton = app.navigationBars.buttons.element(boundBy: 1)
        addMovieButton.tap()
        snapshot("02_search")

        let firstMovieCell = app.cells.element(boundBy: 0)
        firstMovieCell.tap()
        snapshot("search_detail")

        let wantToSeeButton = app.segmentedControls.buttons.element(boundBy: 0)
        wantToSeeButton.swipeDownToElement().tap()
        snapshot("search_marked_as_mustsee")

        let back = app.navigationBars.buttons.element(boundBy: 0)
        back.tap()
        back.tap()

        XCTAssertEqual(app.cells.count, 1)
        snapshot("03_watchlist")

        let wantToSeeMovie = app.cells.element(boundBy: 0)
        wantToSeeMovie.tap()
        snapshot("01_watchlist_detail")

        let seenButton = app.segmentedControls.buttons.element(boundBy: 1)
        seenButton.swipeDownToElement().tap()

        back.tap()

        let seenTab = app.buttons["SeenTab"]
        guard seenTab.waitForExistence(timeout: 1) else {
            XCTFail("Could not navigate to Seen Tab")
            return
        }
        seenTab.tap()
        XCTAssertEqual(app.cells.count, 1)
        snapshot("seenList")

        let seenMovie = app.cells.element(boundBy: 0)
        seenMovie.tap()
        snapshot("seen_detail")

        back.tap()

        let startMovieNightButton = app.navigationBars.buttons.element(boundBy: 0)
        startMovieNightButton.tap()

        let usernameAlert = app.alerts.element(boundBy: 0)
        if usernameAlert.exists {
            snapshot("startMovieNight_usernameAlert")
            let textField = usernameAlert.textFields.element(boundBy: 0)
            textField.tap()
            textField.typeText("Screenshots")
            let saveButton = usernameAlert.buttons.element(boundBy: 1)
            saveButton.tap()
        }

        let nearbyAlert = app.alerts.element(boundBy: 0)
        if nearbyAlert.exists {
            snapshot("startMovieNight_nearbyAlert")
            let moreInfoButton = nearbyAlert.buttons.element(boundBy: 0)
            moreInfoButton.tap()
            snapshot("startMovieNight_nearbyAlert_moreInfo")
            let allowNearbyButton = app.buttons.element(boundBy: 1)
            allowNearbyButton.tap()
        }
        snapshot("startMovieNight_searching")

        //use DEBUG triple tap to test nearby feature
        app.tap()
        app.tap()
        app.tap()

        snapshot("04_startMovieNight_friendsFound")

        let startButton = app.buttons.element(boundBy: 1)
        startButton.tap()
        snapshot("startMovieNight_results")

        back.tap()
        back.tap()

        let settingsTab = app.buttons["SettingsTab"]
        settingsTab.tap()
        snapshot("05_settings")

        let aboutTheApp = app.cells.element(boundBy: 0)
        aboutTheApp.tap()
        snapshot("settings_aboutTheApp")

        back.tap()
        let license = app.cells.element(boundBy: 1)
        license.tap()
        snapshot("settings_license")
    }

    private func resetMoviesIfNeeded() {
        let back = app.navigationBars.buttons.element(boundBy: 0)

        app.buttons["SeenTab"].tap()
        if app.cells.count > 0 {
            app.cells.element(boundBy: 0).tap()
            app.toolbars.buttons.element(boundBy: 0).tap()
            back.tap()
        }
        XCTAssertEqual(app.cells.count, 0)

        app.buttons["WatchlistTab"].tap()
        if app.cells.count > 0 {
            app.cells.element(boundBy: 0).tap()
            app.toolbars.buttons.element(boundBy: 0).tap()
            back.tap()
        }
        XCTAssertEqual(app.cells.count, 0)
    }

}

extension XCUIElement {
    func swipeDownToElement() -> XCUIElement {
        while !self.isHittable {
            XCUIApplication().swipeUp()
        }
        return self
    }
}
