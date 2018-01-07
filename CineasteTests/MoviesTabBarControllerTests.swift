//
//  MoviesTabBarControllerTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 01.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import XCTest
@testable import Cineaste

class MoviesTabBarControllerTests: XCTestCase {
    let tabBarController = MoviesTabBarController.instantiate()
    
    override func setUp() {
        super.setUp()
    }

    func testTabBarControllerDelegateIsNotNil() {
        tabBarController.viewDidLoad()
        XCTAssertNotNil(tabBarController.delegate)
    }

    func testTabBarViewControllerCount() {
        tabBarController.viewDidLoad()
        XCTAssertEqual(tabBarController.viewControllers?.count, 4)
    }

    func testTabBarViewControllerHierarchy() {
        tabBarController.viewDidLoad()

        for viewController in tabBarController.viewControllers! {
            XCTAssert(viewController is UINavigationController)
        }
    }
    
}
