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
    static let primaryOrange = getPrimaryOrange()
    static let primaryDarkOrange = getPrimaryDarkOrange()

    static let basicYellow = getBasicYellow()
    static let basicWhite = getBasicWhite()
    static let basicBackground = getBasicBackground()
    static let basicBlack = getBasicBlack()

    static let superLightGray = getSuperLightGray()

    static let accentTextOnWhite = getAccentTextOnWhite()
    static let accentTextOnBlack = getAccentTextOnBlack()

    static let transparentBlack = getTransparentBlack()

    // Colors with Xcode 11 can't be initialized on iOS 11
    // due to this bug: FB7144402

    static func getPrimaryOrange() -> UIColor {
        if #available(iOS 11, *) {
            return #colorLiteral(red: 0.9176470588, green: 0.337254902, blue: 0.1882352941, alpha: 1)
        } else {
            return UIColor(named: "primaryOrange") ?? .lightGray
        }
    }
    static func getPrimaryDarkOrange() -> UIColor {
        if #available(iOS 11, *) {
            return #colorLiteral(red: 0.7294117647, green: 0.2666666667, blue: 0.1490196078, alpha: 1)
        } else {
            return UIColor(named: "primaryDarkOrange") ?? .lightGray
        }
    }
    static func getBasicYellow() -> UIColor {
        if #available(iOS 11, *) {
            return #colorLiteral(red: 0.9843137255, green: 0.8862745098, blue: 0.1803921569, alpha: 1)
        } else {
            return UIColor(named: "basicYellow") ?? .lightGray
        }
    }
    static func getBasicWhite() -> UIColor {
        if #available(iOS 11, *) {
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        } else {
            return UIColor(named: "basicWhite") ?? .lightGray
        }
    }
    static func getBasicBackground() -> UIColor {
        if #available(iOS 11, *) {
            return #colorLiteral(red: 0.2549019608, green: 0.2901960784, blue: 0.3176470588, alpha: 1)
        } else {
            return UIColor(named: "basicBackground") ?? .lightGray
        }
    }
    static func getBasicBlack() -> UIColor {
        if #available(iOS 11, *) {
            return #colorLiteral(red: 0.1458641843, green: 0.157300925, blue: 0.1739156683, alpha: 1)
        } else {
            return UIColor(named: "basicBlack") ?? .lightGray
        }
    }
    static func getSuperLightGray() -> UIColor {
        if #available(iOS 11, *) {
            return #colorLiteral(red: 0.7537454963, green: 0.7489073873, blue: 0.7746431231, alpha: 1)
        } else {
            return UIColor(named: "superLightGray") ?? .lightGray
        }
    }
    static func getAccentTextOnWhite() -> UIColor {
        if #available(iOS 11, *) {
            return #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5019607843, alpha: 1)
        } else {
            return UIColor(named: "accentTextOnWhite") ?? .lightGray
        }
    }
    static func getAccentTextOnBlack() -> UIColor {
        if #available(iOS 11, *) {
            return #colorLiteral(red: 0.8837971091, green: 0.8855347633, blue: 0.9063164592, alpha: 1)
        } else {
            return UIColor(named: "accentTextOnBlack") ?? .lightGray
        }
    }
    static func getTransparentBlack() -> UIColor {
        if #available(iOS 11, *) {
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)
        } else {
            return UIColor(named: "transparentBlack") ?? .lightGray
        }
    }
}
