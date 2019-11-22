//
//  ShortcutItemRefresher.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 22.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import UIKit

enum ShortcutItemRefresher {

    static func refreshShortcutItems(for movies: Set<Movie>) {
        let moviesToWatch = movies.filter { !($0.watched ?? false) }
        let seenMovies = movies.filter { $0.watched ?? false }

        var shortcuts: [UIApplicationShortcutItem] = []

        if !moviesToWatch.isEmpty {
            let watchlistShortcutItem = watchlistShortcut(for: String.movies(for: moviesToWatch.count))
            shortcuts.append(watchlistShortcutItem)
        }

        if !seenMovies.isEmpty {
            let seenShortcutItem = seenShortcut(for: String.movies(for: seenMovies.count))
            shortcuts.append(seenShortcutItem)
        }

        UIApplication.shared.shortcutItems = shortcuts
    }

    private static func watchlistShortcut(for counterDescription: String) -> UIApplicationShortcutItem {
        UIApplicationShortcutItem(
            type: ShortcutIdentifier.watchlist.rawValue,
            localizedTitle: String.watchlist,
            localizedSubtitle: counterDescription,
            icon: UIApplicationShortcutIcon(templateImageName: "watchlist"),
            userInfo: nil
        )
    }

    private static func seenShortcut(for counterDescription: String) -> UIApplicationShortcutItem {
        UIApplicationShortcutItem(
            type: ShortcutIdentifier.seen.rawValue,
            localizedTitle: String.seen,
            localizedSubtitle: counterDescription,
            icon: UIApplicationShortcutIcon(templateImageName: "seen"),
            userInfo: nil
        )
    }
}
