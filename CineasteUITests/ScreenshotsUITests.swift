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
        app.launchArguments = [
            "-AppleLanguages",
            "(de)",
            "-AppleLocale",
            "de_DE"
        ]
        app.launch()
        setupSnapshot(app)
    }

    func testScreenshots() {
        let app = XCUIApplication()
        snapshot("01_emptyList")

        let addMovieButton = app.navigationBars.buttons.element(boundBy: 1)
        addMovieButton.tap()
        snapshot("02_search")

        let firstMovieCell = app.cells.element(boundBy: 0)
        firstMovieCell.tap()
        snapshot("03_search_detail")

        let wantToSeeButton = app.buttons["detail.mustsee.button"]
        wantToSeeButton.tap()
        snapshot("04_wantToSeeList")

        let wantToSeeMovie = app.cells.element(boundBy: 0)
        wantToSeeMovie.tap()
        let seenButton = app.buttons["detail.seen.button"]
        seenButton.tap()
        let seenTab = app.buttons["SeenTab"]
        seenTab.tap()
        snapshot("05_seenList")

        let startMovieNightButton = app.navigationBars.buttons.element(boundBy: 0)
        startMovieNightButton.tap()

        let usernameAlert = app.alerts.element(boundBy: 0)
        if usernameAlert.exists {
            snapshot("06_startMovieNight_usernameAlert")
            let textField = usernameAlert.textFields.element(boundBy: 0)
            textField.tap()
            textField.typeText("Screenshots")
            let saveButton = usernameAlert.buttons.element(boundBy: 1)
            saveButton.tap()
        }

        let nearbyAlert = app.alerts.element(boundBy: 0)
        if nearbyAlert.exists {
            snapshot("07_startMovieNight_nearbyAlert")
            let moreInfoButton = nearbyAlert.buttons.element(boundBy: 0)
            moreInfoButton.tap()
            snapshot("08_startMovieNight_nearbyAlert_moreInfo")
            let allowNearbyButton = app.buttons.element(boundBy: 1)
            allowNearbyButton.tap()
        }
        snapshot("09_startMovieNight_searching")

        let cancel = app.navigationBars.buttons.element(boundBy: 0)
        cancel.tap()

        let settingsTab = app.buttons["SettingsTab"]
        settingsTab.tap()
        snapshot("10_settings")

        let aboutTheApp = app.cells.element(boundBy: 0)
        aboutTheApp.tap()
        snapshot("11_settings_aboutTheApp")

        let back = app.navigationBars.buttons.element(boundBy: 0)
        back.tap()
        let license = app.cells.element(boundBy: 1)
        license.tap()
        snapshot("12_settings_license")
    }

}
