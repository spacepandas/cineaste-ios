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
    static let basicWhite = UIColor(named: "basicWhite") ?? .lightGray
    static let basicBackground = UIColor(named: "basicBackground") ?? .lightGray
    static let basicBlack = UIColor(named: "basicBlack") ?? .lightGray

    static let superLightGray = UIColor(named: "superLightGray") ?? .lightGray

    static let accentTextOnWhite = UIColor(named: "accentTextOnWhite") ?? .lightGray
    static let accentTextOnBlack = UIColor(named: "accentTextOnBlack") ?? .lightGray

    static let transparentBlack = UIColor(named: "transparentBlack") ?? .lightGray
}
