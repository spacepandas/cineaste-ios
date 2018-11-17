//
//  ScreenshotsUITests.swift
//  ScreenshotsUITests
//
//  Created by Felizia Bernutz on 20.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import XCTest

class ScreenshotsUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        let app: XCUIApplication = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    func testScreenshots() {
        let app = XCUIApplication()
        snapshot("emptyList")

        let addMovieButton = app.navigationBars.buttons.element(boundBy: 1)
        addMovieButton.tap()
        snapshot("02_search")

        let firstMovieCell = app.cells.element(boundBy: 0)
        firstMovieCell.tap()
        snapshot("search_detail")

        let wantToSeeButton = app.buttons["detail.mustsee.button"]
        wantToSeeButton.tap()
        snapshot("03_wantToSeeList")

        let wantToSeeMovie = app.cells.element(boundBy: 0)
        wantToSeeMovie.tap()
        snapshot("01_wantToSee_detail")

        let seenButton = app.buttons["detail.seen.button"]
        seenButton.tap()
        let seenTab = app.buttons["SeenTab"]
        seenTab.tap()
        snapshot("seenList")

        let seenMovie = app.cells.element(boundBy: 0)
        seenMovie.tap()
        snapshot("seen_detail")

        let back = app.navigationBars.buttons.element(boundBy: 0)
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

}
