//
//  MoviesTabBarController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 01.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class MoviesTabBarController: UITabBarController {

    private weak var lastViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self

        let watchlistVC = MoviesViewController.instantiate()
        watchlistVC.category = .watchlist
        watchlistVC.tabBarItem = UITabBarItem(
            title: String.watchlist,
            image: UIImage.watchlistIcon,
            tag: 0)
        watchlistVC.tabBarItem.accessibilityIdentifier = "WatchlistTab"
        let watchlistVCWithNavi = NavigationController(rootViewController: watchlistVC)

        let seenVC = MoviesViewController.instantiate()
        seenVC.category = .seen
        seenVC.tabBarItem = UITabBarItem(
            title: String.seen,
            image: UIImage.seenIcon,
            tag: 1)
        seenVC.tabBarItem.accessibilityIdentifier = "SeenTab"
        let seenVCWithNavi = NavigationController(rootViewController: seenVC)

        let settingsVC = SettingsViewController.instantiate()
        settingsVC.tabBarItem = UITabBarItem(
            title: String.moreTitle,
            image: UIImage.moreIcon,
            tag: 2)
        settingsVC.tabBarItem.accessibilityIdentifier = "SettingsTab"
        let settingsVCWithNavi = NavigationController(rootViewController: settingsVC)

        viewControllers = [watchlistVCWithNavi, seenVCWithNavi, settingsVCWithNavi]
    }
}

extension MoviesTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        lastViewController = tabBarController.selectedViewController
        return true
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard lastViewController == viewController,
            let navi = viewController as? UINavigationController,
            let tvc = navi.topViewController as? UITableViewController,
            !tvc.tableView.visibleCells.isEmpty
            else { return }

        tvc.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}

extension MoviesTabBarController: Instantiable {
    static var storyboard: Storyboard { return .main }
    static var storyboardID: String? { return "MoviesTabBarController" }
}
