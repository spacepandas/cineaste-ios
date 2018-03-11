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

        let wantToSeeVC = MoviesViewController.instantiate()
        wantToSeeVC.category = .wantToSee
        wantToSeeVC.tabBarItem = UITabBarItem(title: Strings.wantToSeeTab, image: MovieListCategory.wantToSee.image, tag: 0)
        let wantToSeeVCWithNavi = UINavigationController(rootViewController: wantToSeeVC)

        let seenVC = MoviesViewController.instantiate()
        seenVC.category = .seen
        seenVC.tabBarItem = UITabBarItem(title: Strings.seenTab, image: MovieListCategory.seen.image, tag: 1)
        let seenVCWithNavi = UINavigationController(rootViewController: seenVC)

        let settingsVC = SettingsViewController.instantiate()
        settingsVC.tabBarItem = UITabBarItem(title: Strings.settingTab, image: nil, tag: 2)
        let settingsVCWithNavi = UINavigationController(rootViewController: settingsVC)

        viewControllers = [wantToSeeVCWithNavi, seenVCWithNavi, settingsVCWithNavi]
    }
}

extension MoviesTabBarController: Instantiable {
    static var storyboard: Storyboard { return .main }
    static var storyboardID: String? { return "MoviesTabBarController" }
}
