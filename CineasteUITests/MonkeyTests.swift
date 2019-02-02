//
//  MonkeyTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 02.02.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import XCTest
import SwiftMonkey

class MonkeyTests: XCTestCase {
    let application = XCUIApplication()

    override func setUp() {
        super.setUp()

        application.launchArguments = ["--MonkeyPaws"]
        application.launch()
    }

    func testMonkey() {
        // Initialise the monkey tester with the current device
        // frame. Giving an explicit seed will make it generate
        // the same sequence of events on each run, and leaving it
        // out will generate a new sequence on each run.
        let monkey = Monkey(frame: application.frame)
        //let monkey = Monkey(seed: 123, frame: application.frame)

        // Add actions for the monkey to perform. We just use a
        // default set of actions for this, which is usually enough.
        // Use either one of these, but maybe not both.
        // XCTest private actions seem to work better at the moment.
        // UIAutomation actions seem to work only on the simulator.
        monkey.addDefaultXCTestPrivateActions()
        //monkey.addDefaultUIAutomationActions()

        // Occasionally, use the regular XCTest functionality
        // to check if an alert is shown, and click a random
        // button on it.
        monkey.addXCTestTapAlertAction(interval: 100, application: application)

        // Run the monkey test indefinitely.
        monkey.monkeyAround()
    }
}
