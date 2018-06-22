//
//  SettingItem.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 11.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

enum SettingItem {
    case exportMovies
    case importMovies
    case licence
    case about

    var title: String {
        switch self {
        case .exportMovies:
            return String.exportTitle
        case .importMovies:
            return String.importTitle
        case .licence:
            return String.licenseTitle
        case .about:
            return String.aboutAppTitle
        }
    }

    var description: String? {
        switch self {
        case .exportMovies:
            return String.exportDescription
        case .importMovies:
            return String.importDescription
        case .licence:
            return nil
        case .about:
            return nil
        }
    }

    var segue: Segue? {
        switch self {
        case .exportMovies:
            return nil
        case .importMovies:
            return nil
        case .licence:
            return .showTextViewFromSettings
        case .about:
            return .showTextViewFromSettings
        }
    }
}
