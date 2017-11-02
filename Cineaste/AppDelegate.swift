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

    var persistentContainer: NSPersistentContainer!
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func createMovieContainer(completion: @escaping(NSPersistentContainer) -> ()) {
        let container = NSPersistentContainer(name:"Movie")
        container.loadPersistentStores {_, error in
            guard error == nil else {
                fatalError("Failed to load store: \(error!)")
            }
            DispatchQueue.main.async {
                completion(container)
            }
        }
    }

}

