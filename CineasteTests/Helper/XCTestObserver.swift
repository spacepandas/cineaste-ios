//
//  XCTestObserver.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 08.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import XCTest
@testable import ReSwift
@testable import Cineaste_App

final class XCTestObserver: NSObject, XCTestObservation {

    override init() {
        super.init()
        XCTestObservationCenter.shared.addTestObserver(self)
        resetStore()
    }

    func testBundleWillStart(_ testBundle: Bundle) {
        UIView.setAnimationsEnabled(false)
    }

    func testBundleDidFinish(_ testBundle: Bundle) {
        UIView.setAnimationsEnabled(true)
    }

    func testCaseWillStart(_ testCase: XCTestCase) {
        resetStore()
    }

    private func resetStore() {
        store = Store(reducer: appReducer, state: AppState())
        store.dispatchFunction = { _ in }
        store.subscriptions
            .compactMap { $0.subscriber }
            .forEach(store.unsubscribe)
    }
}
