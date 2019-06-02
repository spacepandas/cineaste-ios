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
    case name
    case exportMovies
    case importMovies
    case contact
    case appStore

    var title: String {
        switch self {
        case .about:
            return .aboutAppTitle
        case .licence:
            return .licenseTitle
        case .name:
            if let name = UsernamePersistence.username {
                return .username + ": \(name)"
            } else {
                return .username
            }
        case .exportMovies:
            return .exportTitle
        case .importMovies:
            return .importTitle
        case .contact:
            return .contactTitle
        case .appStore:
            return .appStoreTitle
        }
    }

    var description: String? {
        switch self {
        case .licence,
             .about,
             .contact,
             .appStore:
            return nil
        case .name:
            return UsernamePersistence.username != nil
                ? .changeUsernameDescription
                : .insertUsernameDescription
        case .exportMovies:
            return .exportDescription
        case .importMovies:
            return .importDescription
        }
    }

    var segue: Segue? {
        switch self {
        case .about:
            return .showTextViewFromSettings
        case .licence:
            return .showTextViewFromSettings
        case .name,
             .exportMovies,
             .importMovies,
             .contact,
             .appStore:
            return nil
        }
    }
}
