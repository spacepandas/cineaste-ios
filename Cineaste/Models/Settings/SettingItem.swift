//
//  SettingItem.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 11.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

enum SettingItem: CaseIterable {
    case about
    case licence
    case refreshMovies
    case exportMovies
    case importMovies
    case contact
    case appStore

    var title: String {
        switch self {
        case .about:
            return String.aboutAppTitle
        case .licence:
            return String.licenseTitle
        case .refreshMovies:
            return RefreshMode.default.menuTitle
        case .exportMovies:
            return String.exportTitle
        case .importMovies:
            return String.importTitle
        case .contact:
            return String.contactTitle
        case .appStore:
            return String.appStoreTitle
        }
    }

    var description: String? {
        switch self {
        case .licence,
             .about,
             .contact,
             .appStore:
            return nil
        case .refreshMovies:
            return RefreshMode.default.menuDescription
        case .exportMovies:
            return String.exportDescription
        case .importMovies:
            return String.importDescription
        }
    }

    var segue: Segue? {
        switch self {
        case .about:
            return .showTextViewFromSettings
        case .licence:
            return .showTextViewFromSettings
        case .refreshMovies,
             .exportMovies,
             .importMovies,
             .contact,
             .appStore:
            return nil
        }
    }
}
