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

        let storageManager = MovieStorageManager()

        let watchlistVC = MoviesViewController.instantiate()
        watchlistVC.category = .watchlist
        watchlistVC.tabBarItem = UITabBarItem(
            title: String.watchlist,
            image: UIImage.watchlistIcon,
            tag: 0)
        watchlistVC.tabBarItem.accessibilityIdentifier = "WatchlistTab"
        watchlistVC.storageManager = storageManager
        let watchlistVCWithNavi = OrangeNavigationController(rootViewController: watchlistVC)

        let seenVC = MoviesViewController.instantiate()
        seenVC.category = .seen
        seenVC.tabBarItem = UITabBarItem(
            title: String.seen,
            image: UIImage.seenIcon,
            tag: 1)
        seenVC.tabBarItem.accessibilityIdentifier = "SeenTab"
        seenVC.storageManager = storageManager
        let seenVCWithNavi = OrangeNavigationController(rootViewController: seenVC)

        let settingsVC = SettingsViewController.instantiate()
        settingsVC.tabBarItem = UITabBarItem(
            title: String.moreTitle,
            image: UIImage.moreIcon,
            tag: 2)
        settingsVC.tabBarItem.accessibilityIdentifier = "SettingsTab"
        settingsVC.storageManager = storageManager
        let settingsVCWithNavi = OrangeNavigationController(rootViewController: settingsVC)

        viewControllers = [watchlistVCWithNavi, seenVCWithNavi, settingsVCWithNavi]
    }
}

extension MoviesTabBarController: Instantiable {
    static var storyboard: Storyboard { return .main }
    static var storyboardID: String? { return "MoviesTabBarController" }
}
