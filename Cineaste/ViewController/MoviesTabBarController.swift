//
//  MoviesTabBarController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 01.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class MoviesTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let storageManager = MovieStorage()

        let wantToSeeVC = MoviesViewController.instantiate()
        wantToSeeVC.category = .wantToSee
        wantToSeeVC.tabBarItem = UITabBarItem(title: String.wantToSeeList, image: MovieListCategory.wantToSee.image, tag: 0)
        wantToSeeVC.tabBarItem.accessibilityIdentifier = "WantToSeeTab"
        wantToSeeVC.storageManager = storageManager
        let wantToSeeVCWithNavi = OrangeNavigationController(rootViewController: wantToSeeVC)

        let seenVC = MoviesViewController.instantiate()
        seenVC.category = .seen
        seenVC.tabBarItem = UITabBarItem(title: String.seenList, image: MovieListCategory.seen.image, tag: 1)
        seenVC.tabBarItem.accessibilityIdentifier = "SeenTab"
        seenVC.storageManager = storageManager
        let seenVCWithNavi = OrangeNavigationController(rootViewController: seenVC)

        let settingsVC = SettingsViewController.instantiate()
        settingsVC.tabBarItem = UITabBarItem(title: String.settingTab, image: UIImage.settingsIcon, tag: 2)
        settingsVC.tabBarItem.accessibilityIdentifier = "SettingsTab"
        let settingsVCWithNavi = OrangeNavigationController(rootViewController: settingsVC)

        viewControllers = [wantToSeeVCWithNavi, seenVCWithNavi, settingsVCWithNavi]
    }
}

extension MoviesTabBarController: Instantiable {
    static var storyboard: Storyboard { return .main }
    static var storyboardID: String? { return "MoviesTabBarController" }
}
