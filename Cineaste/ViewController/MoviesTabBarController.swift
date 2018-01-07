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
        self.delegate = self

        let wantToSeeVC = MoviesViewController.instantiate()
        wantToSeeVC.category = .wantToSee
        wantToSeeVC.tabBarItem = UITabBarItem(title: MyMovieListCategory.wantToSee.tabBarTitle, image: #imageLiteral(resourceName: "add_to_watchlist"), tag: 0)
        let wantToSeeVCWithNavi = UINavigationController(rootViewController: wantToSeeVC)

        let seenVC = MoviesViewController.instantiate()
        seenVC.category = .seen
        seenVC.tabBarItem = UITabBarItem(title: MyMovieListCategory.seen.tabBarTitle, image: #imageLiteral(resourceName: "add_to_watchedlist"), tag: 1)
        let seenVCWithNavi = UINavigationController(rootViewController: seenVC)

        let imprintVC = ImprintViewController.instantiate()
        imprintVC.tabBarItem = UITabBarItem(title: "About", image: nil, tag: 2)
        let imprintVCWithNavi = UINavigationController(rootViewController: imprintVC)

        viewControllers = [wantToSeeVCWithNavi, seenVCWithNavi, imprintVCWithNavi]
    }

}

extension MoviesTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let moviesVC = viewController.childViewControllers.first as? MoviesViewController {
            moviesVC.category = tabBarController.selectedIndex == 0 ? .wantToSee : .seen
        }
    }
}

extension MoviesTabBarController: Instantiable {
    static var storyboard: Storyboard { return .main }
    static var storyboardID: String? { return "MoviesTabBarController" }
}
