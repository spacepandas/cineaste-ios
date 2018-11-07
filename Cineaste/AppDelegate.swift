//
//  AppDelegate.swift
//  Cineaste
//
//  Created by Christian Braun on 16.10.17.
//  Copyright notimeforthat.org. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let movieRefresher = MovieRefresher(refreshMode: .always)

    // swiftlint:disable:next discouraged_optional_collection
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(contextDidSave(notification:)),
                         name: NSNotification.Name.NSManagedObjectContextDidSave,
                         object: nil)

        Appearance.setup()
        movieRefresher.refreshMoviesInDatabase()

        // check if system launched the app with a quick action
        // return false so performActionForShortcutItem: is not called twice
        if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem]
            as? UIApplicationShortcutItem {
            _ = handle(shortCut: shortcutItem)
            return false
        }

        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        movieRefresher.refreshMoviesInDatabase()
    }

    // MARK: - Home Quick Actions

    func application(_ application: UIApplication,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handle(shortCut: shortcutItem))
    }

    private func handle(shortCut shortcutItem: UIApplicationShortcutItem) -> Bool {
        let shortcutType = shortcutItem.type
        guard let shortcutIdentifier = ShortcutIdentifier(rawValue: shortcutType),
            let tabBarVC = window?.rootViewController as? MoviesTabBarController
            else { return false }

        switch shortcutIdentifier {
        case .watchlist:
            tabBarVC.selectedIndex = 0
            return true
        case .seen:
            tabBarVC.selectedIndex = 1
            return true
        case .startMovieNight:
            guard
                let moviesVC = tabBarVC.selectedViewController?
                    .children.first as? MoviesViewController
                else { return false }

            moviesVC.movieNightButtonTouched(UIBarButtonItem())
            return true
        }

    }

    // MARK: - Core Data

    @objc
    func contextDidSave(notification: Notification) {
        AppDelegate.viewContext.perform {
            AppDelegate.viewContext.mergeChanges(fromContextDidSave: notification)
        }
    }

    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        return container
    }()

    static var viewContext: NSManagedObjectContext {
        return AppDelegate.persistentContainer.viewContext
    }
}
