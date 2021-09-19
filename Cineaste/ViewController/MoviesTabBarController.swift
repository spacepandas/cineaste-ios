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

        if #available(iOS 13.0, *) {
            // TabBarItem configuration for iOS 13+
            let tabBarItemAppearance = UITabBarItemAppearance()
            tabBarItemAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor.cineTabBarSelected
            ]
            tabBarItemAppearance.selected.iconColor = .cineTabBarSelected
            tabBarItemAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.cineTabBarNormal
            ]
            tabBarItemAppearance.normal.iconColor = .cineTabBarNormal

            // TabBar configuration for iOS 13+
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = .cineTabBar
            appearance.inlineLayoutAppearance = tabBarItemAppearance
            appearance.stackedLayoutAppearance = tabBarItemAppearance
            appearance.compactInlineLayoutAppearance = tabBarItemAppearance
            tabBar.standardAppearance = appearance

            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = appearance
            }
        } else {
            // TabBarItem configuration for iOS 12
            let tabBarItem = UITabBarItem.appearance()
            tabBarItem.setTitleTextAttributes(
                [
                    .foregroundColor: UIColor.cineTabBarSelected
                ],
                for: .selected
            )
            tabBarItem.setTitleTextAttributes(
                [
                    .foregroundColor: UIColor.cineTabBarNormal
                ],
                for: .normal
            )

            // TabBar configuration for iOS 12
            let tabBar = UITabBar.appearance()
            tabBar.isTranslucent = false
            tabBar.tintColor = .cineTabBarSelected
            tabBar.barTintColor = .cineTabBar
            tabBar.unselectedItemTintColor = .cineTabBarNormal
        }

        delegate = self

        let watchlistVC = MoviesViewController.instantiate()
        watchlistVC.category = .watchlist
        watchlistVC.tabBarItem = UITabBarItem(
            title: String.watchlist,
            image: UIImage.watchlistIcon,
            tag: 0
        )
        watchlistVC.tabBarItem.accessibilityIdentifier = "WatchlistTab"
        let watchlistVCWithNavi = NavigationController(rootViewController: watchlistVC)

        let seenVC = MoviesViewController.instantiate()
        seenVC.category = .seen
        seenVC.tabBarItem = UITabBarItem(
            title: String.seen,
            image: UIImage.seenIcon,
            tag: 1
        )
        seenVC.tabBarItem.accessibilityIdentifier = "SeenTab"
        let seenVCWithNavi = NavigationController(rootViewController: seenVC)

        let searchVC = SearchMoviesViewController.instantiate()
        searchVC.tabBarItem = UITabBarItem(
            title: String.searchTitle,
            image: UIImage.searchIcon,
            tag: 2
        )
        searchVC.tabBarItem.accessibilityIdentifier = "SearchTab"
        let searchVCWithNavi = NavigationController(rootViewController: searchVC)

        let settingsVC = SettingsViewController.instantiate()
        settingsVC.tabBarItem = UITabBarItem(
            title: String.moreTitle,
            image: UIImage.moreIcon,
            tag: 3
        )
        settingsVC.tabBarItem.accessibilityIdentifier = "SettingsTab"
        let settingsVCWithNavi = NavigationController(rootViewController: settingsVC)

        viewControllers = [
            watchlistVCWithNavi,
            seenVCWithNavi,
            searchVCWithNavi,
            settingsVCWithNavi
        ]
    }
}

extension MoviesTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        lastViewController = tabBarController.selectedViewController
        return true
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard lastViewController == viewController,
            let navi = viewController as? UINavigationController
            else { return }

        var possibleTableView: UITableView?
        if let topVC = navi.topViewController as? MoviesViewController {
            possibleTableView = topVC.tableView
        } else if let topVC = navi.topViewController as? SearchMoviesViewController {
            possibleTableView = topVC.tableView
        } else if let topVC = navi.topViewController as? SettingsViewController {
            possibleTableView = topVC.tableView
        } else if let topVC = navi.topViewController as? UITableViewController {
            possibleTableView = topVC.tableView
        }

        guard let tableView = possibleTableView,
            !tableView.visibleCells.isEmpty
            else { return }

        tableView.scrollToRow(
            at: IndexPath(row: 0, section: 0),
            at: .top,
            animated: true
        )
    }
}

extension MoviesTabBarController: Instantiable {
    static var storyboard: Storyboard { .main }
    static var storyboardID: String? { "MoviesTabBarController" }
}
