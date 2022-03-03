//
//  AppLaunchPerformanceUITests.swift
//  CineasteUITests
//
//  Created by Felizia Bernutz on 26.10.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import XCTest

class AppLaunchPerformanceUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    func testAppLaunchTime() {
        measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
            XCUIApplication().launch()
        }
    }

}
