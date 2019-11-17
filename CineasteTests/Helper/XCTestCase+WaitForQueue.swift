//
//  XCTestCase+WaitForQueue.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 17.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import XCTest

extension XCTestCase {
    /// Waits a while on the given `queue`
    /// Use this to wait for animations or when presenting/dismissing views
    ///
    /// - Parameters:
    ///   - queue: The queue to block / wait on
    ///   - delay: How long to wait on the queue
    ///   - timeout: Timeout for expectation
    ///   - description: The description when the timeout is reached
    func waitForQueue(queue: DispatchQueue = .main,
                      delay: TimeInterval = 0,
                      timeout: TimeInterval = 5,
                      description: String = #function) {

        assert(delay < timeout, "This expectation can never be fulfilled")

        let exp = expectation(description: description)
        queue.asyncAfter(deadline: .now() + delay) { exp.fulfill() }
        wait(for: [exp], timeout: timeout)
    }
}
