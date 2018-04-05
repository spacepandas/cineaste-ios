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
            return Strings.exportTitle
        case .importMovies:
            return Strings.importTitle
        case .licence:
            return Strings.licenceTitle
        case .about:
            return Strings.aboutAppTitle
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
