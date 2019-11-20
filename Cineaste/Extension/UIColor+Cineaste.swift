//
//  UIColor+Cineaste.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 21.07.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit

// The default values are needed due to this bug: 41244137
// (Force unwrapping fails in Interface Builder)

extension UIColor {
    // MARK: NavBar
    static let cineNavBar = UIColor(named: "navBar") ?? .lightGray
    static let cineNavBarTint = UIColor(named: "navBarTint") ?? .lightGray
    static let cineNavBarTitle = UIColor(named: "navBarTitle") ?? .lightGray

    // MARK: TabBar
    static let cineTabBar = UIColor(named: "tabBar") ?? .lightGray
    static let cineTabBarSelected = UIColor(named: "tabBarSelected") ?? .lightGray
    static let cineTabBarNormal = UIColor(named: "tabBarNormal") ?? .lightGray

    // MARK: SegmentedControl
    static let cineSegmentedControlTint = UIColor(named: "segmentedControlTint") ?? .lightGray

    // MARK: Search TextField
    static let cineSearchBackground = UIColor(named: "searchBackground") ?? .lightGray
    static let cineSearchTint = UIColor(named: "searchTint") ?? .lightGray
    static let cineSearchInput = UIColor(named: "searchInput") ?? .lightGray
    static let cineSearchPlaceholder = UIColor(named: "searchPlaceholder") ?? .lightGray

    // MARK: ToolBar
    static let cineToolBarBackground = UIColor(named: "toolBarBackground") ?? .lightGray
    static let cineToolBarTint = UIColor(named: "toolBarTint") ?? .lightGray

    // MARK: Safari
    static let cineSafariBackground = UIColor(named: "safariBackground") ?? .lightGray
    static let cineSafariTint = UIColor(named: "safariTint") ?? .lightGray

    // MARK: SwipeAction
    static let cineSwipeSeen = UIColor(named: "swipeSeen") ?? .lightGray
    static let cineSwipeWatchlist = UIColor(named: "swipeWatchlist") ?? .lightGray
    static let cineSwipeDelete = UIColor(named: "swipeDelete") ?? .lightGray

    // MARK: More...
    static let cineListBackground = UIColor(named: "listBackground") ?? .lightGray
    static let cineSeparator = UIColor(named: "separator") ?? .lightGray
    static let cineCellBackground = UIColor(named: "cellBackground") ?? .lightGray
    static let cineContentBackground = UIColor(named: "cellBackground") ?? .lightGray
    static let cineVoteCircle = UIColor(named: "voteCircle") ?? .lightGray
    static let cineVoteRectangle = UIColor(named: "voteRectangle") ?? .lightGray
    static let cineButton = UIColor(named: "button") ?? .lightGray
    static let cineButtonDark = UIColor(named: "buttonDark") ?? .lightGray
    static let cineTitle = UIColor(named: "title") ?? .lightGray
    static let cineDescription = UIColor(named: "description") ?? .lightGray
    static let cineLink = UIColor(named: "link") ?? .lightGray
    static let cineImageTint = UIColor(named: "imageTint") ?? .lightGray
    static let cineAlertTint = UIColor(named: "alertTint") ?? .lightGray
    static let cineShadow = UIColor(named: "shadow") ?? .lightGray
    static let cineFooter = UIColor(named: "footer") ?? .lightGray
    static let cineEmptyListDescription = UIColor(named: "emptyListDescription") ?? .lightGray
    static let cineUsageActive = UIColor(named: "usageActive") ?? .lightGray
    static let cineUsageInactive = UIColor(named: "usageInactive") ?? .lightGray
}
