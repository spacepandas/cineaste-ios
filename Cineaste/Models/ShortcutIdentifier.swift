//
//  ShortcutIdentifier.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 11.03.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

enum ShortcutIdentifier: String {
    case startMovieNight
    case watchlist
    case seen
    case discover

    func navigate(from tabBarVC: UITabBarController) -> Bool {
        switch self {
        case .watchlist:
            tabBarVC.selectedIndex = 0
        case .seen:
            tabBarVC.selectedIndex = 1
        case .startMovieNight:
            tabBarVC.selectedIndex = 0
            guard let moviesVC = tabBarVC.selectedViewController?
                .children.first as? MoviesViewController
                else { return false }

            moviesVC.movieNightButtonTouched()
        case .discover:
            tabBarVC.selectedIndex = 2
        }

        return true
    }
}
