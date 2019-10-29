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
    static let primaryOrange = UIColor(named: "primaryOrange") ?? .lightGray
    static let primaryDarkOrange = UIColor(named: "primaryDarkOrange") ?? .lightGray

    static let basicYellow = UIColor(named: "basicYellow") ?? .lightGray

    static let basicBackground = UIColor(named: "basicBackground") ?? .lightGray
    static let basicBlack = UIColor(named: "basicBlack") ?? .lightGray

    static let superLightGray = UIColor(named: "superLightGray") ?? .lightGray

    static let accentTextOnWhite = UIColor(named: "accentTextOnWhite") ?? .lightGray
    static let accentTextOnBlack = UIColor(named: "accentTextOnBlack") ?? .lightGray

    static let transparentBlack = UIColor(named: "transparentBlack") ?? .lightGray

    // new
    static let cineNavBar = UIColor(named: "navBar") ?? .lightGray
    static let cineNavBarTint = UIColor(named: "navBarTint") ?? .lightGray
    static let cineNavBarTitle = UIColor(named: "navBarTitle") ?? .lightGray

    static let cineTabBar = UIColor(named: "tabBar") ?? .lightGray
    static let cineTabBarSelected = UIColor(named: "tabBarSelected") ?? .lightGray
    static let cineTabBarNormal = UIColor(named: "tabBarNormal") ?? .lightGray

    static let cineSegmentedControlSelected = UIColor(named: "segmentedControlSelected") ?? .lightGray
    static let cineSegmentedControlNormal = UIColor(named: "segmentedControlNormal") ?? .lightGray
    static let cineSegmentedControlTint = UIColor(named: "segmentedControlTint") ?? .lightGray

    static let cineListBackground = UIColor(named: "listBackground") ?? .lightGray
    static let cineSeparator = UIColor(named: "separator") ?? .lightGray
    static let cineCellBackground = UIColor(named: "cellBackground") ?? .lightGray
    static let cineContentBackground = UIColor(named: "cellBackground") ?? .lightGray
    static let cineVoteCircle = UIColor(named: "voteCircle") ?? .lightGray
    static let cineVoteRectangle = UIColor(named: "voteRectangle") ?? .lightGray
    static let cineButton = UIColor(named: "button") ?? .lightGray

    static let cineTitle = UIColor(named: "title") ?? .lightGray
    static let cineDescription = UIColor(named: "description") ?? .lightGray
    static let cineLink = UIColor(named: "link") ?? .lightGray

    static let cineSearchBackground = UIColor(named: "searchBackground") ?? .lightGray
    static let cineSearchTint = UIColor(named: "searchTint") ?? .lightGray
    static let cineSearchInput = UIColor(named: "searchInput") ?? .lightGray
    static let cineSearchPlaceholder = UIColor(named: "searchPlaceholder") ?? .lightGray

    static let cineImageTint = UIColor(named: "imageTint") ?? .lightGray

    static let cineToolBarBackground = UIColor(named: "toolBarBackground") ?? .lightGray
    static let cineToolBarTint = UIColor(named: "toolBarTint") ?? .lightGray
}
