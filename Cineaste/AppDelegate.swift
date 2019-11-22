//
//  AppDelegate.swift
//  Cineaste
//
//  Created by Christian Braun on 16.10.17.
//  Copyright notimeforthat.org. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let persistenceSubscriber = PersistenceSubscriber()

    // swiftlint:disable:next discouraged_optional_collection
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        // IMPORTANT: Call this before the ReSwift Store is initialized
        // (before ReSwiftInit is dispatched)
        migrateCoreData()

        return true
    }

    // swiftlint:disable:next discouraged_optional_collection
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        handleLaunchArguments()
        Appearance.setup()

        store.subscribe(persistenceSubscriber) { subscription in
            subscription.select { $0.movies }
        }

        // check if system launched the app with a quick action
        // return false so performActionForShortcutItem: is not called twice
        if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem]
            as? UIApplicationShortcutItem {
            handleShortcut(for: shortcutItem)
            return false
        }

        return true
    }

    // MARK: - Home Quick Actions

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleShortcut(for: shortcutItem))
    }

    @discardableResult
    private func handleShortcut(for shortcutItem: UIApplicationShortcutItem) -> Bool {
        let shortcutType = shortcutItem.type
        guard let shortcutIdentifier = ShortcutIdentifier(rawValue: shortcutType),
            let tabBarVC = window?.rootViewController as? MoviesTabBarController
            else { return false }

        switch shortcutIdentifier {
        case .watchlist:
            tabBarVC.selectedIndex = 0
        case .seen:
            tabBarVC.selectedIndex = 1
        case .startMovieNight:
            guard let moviesVC = tabBarVC.selectedViewController?
                .children.first as? MoviesViewController
                else { return false }

            moviesVC.movieNightButtonTouched()
        }

        return true
    }

    // MARK: - Custom functions

    private func handleLaunchArguments() {
        #if DEBUG
        let arguments = ProcessInfo().arguments

        if arguments.contains("SKIP_ANIMATIONS") {
            UIView.setAnimationsEnabled(false)
        }
        #endif
    }

    private func migrateCoreData() {
        let migrator = CoreDataMigrator()
        let movies = migrator.coreDataMovies

        guard !movies.isEmpty else { return }

        try? Persistence.saveMovies(movies)
        try? migrator.clearCoreData()
    }
}
