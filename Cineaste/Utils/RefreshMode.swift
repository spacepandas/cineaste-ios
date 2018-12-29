//
//  RefreshMode.swift
//  Cineaste App
//
//  Created by Xaver Lohmüller on 10.11.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import Foundation

enum RefreshMode: Int { case never, wifi, always }

extension RefreshMode {
    private static let userDefaultsKey = "de.cineaste.refreshMode"

    static var `default`: RefreshMode {
        get {
            let savedValue = UserDefaults.standard.integer(forKey: userDefaultsKey)
            if let refreshMode = RefreshMode(rawValue: savedValue) {
                return refreshMode
            } else {
                return .wifi
            }
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: userDefaultsKey)
        }
    }

    var menuTitle: String {
        switch self {
        case .never:
            return .refreshMoviesTitleNever
        case .wifi:
            return .refreshMoviesTitleWifi
        case .always:
            return .refreshMoviesTitleAlways
        }
    }

    var menuDescription: String {
        switch self {
        case .never:
            return .refreshMoviesDescriptionNever
        case .wifi:
            return .refreshMoviesDescriptionWifi
        case .always:
            return .refreshMoviesDescriptionAlways
        }
    }

    var next: RefreshMode {
        switch self {
        case .never:
            return .wifi
        case .wifi:
            return .always
        case .always:
            return .never
        }
    }
}
