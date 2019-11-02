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

        static func shareUrl(for movie: Movie) -> URL? {
            URL(string: "https://www.themoviedb.org/movie/\(movie.id)")
        }
    }

    static let appStoreUrl = "https://apps.apple.com/app/id1402748020"

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

    static var versionNumberInformation: String {
        guard
            let version = Bundle.main
                .object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
            let build = Bundle.main
                .object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
            else { return "" }
        return "\(String.versionText): \(version) (\(build))"
    }
}
