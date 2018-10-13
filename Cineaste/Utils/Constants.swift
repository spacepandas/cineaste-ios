//
//  Config.swift
//  Cineaste
//
//  Created by Christian Braun on 21.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import Foundation

enum Constants {
    enum Backend {
        static let url = "https://api.themoviedb.org/3"
        static let shareMovieUrl = "https://www.themoviedb.org/movie/"
    }

    static let appStoreUrl = "https://itunes.apple.com/app/id1402748020"

    enum UserDefaults {
        static let usernameKey = "cineaste-username"
    }

    enum PosterSize {
        case small
        case original

        var address: String {
            let host = "https://image.tmdb.org/t/p"

            switch self {
            case .small:
                return "\(host)/w342"
            case .original:
                return "\(host)/original"
            }
        }
    }
}
