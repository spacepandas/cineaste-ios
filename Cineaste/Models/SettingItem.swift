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
            return NSLocalizedString("Export", comment: "Title for settings cell exportMovies")
        case .importMovies:
            return NSLocalizedString("Import", comment: "Title for settings cell importMovies")
        case .licence:
            return NSLocalizedString("Lizenzen", comment: "Title for settings cell licence")
        case .about:
            return NSLocalizedString("Über die App", comment: "Title for settings cell about")
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
