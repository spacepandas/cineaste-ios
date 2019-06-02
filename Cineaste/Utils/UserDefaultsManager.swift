//
//  UsernamePersistence.swift
//  Cineaste
//
//  Created by Christian Braun on 21.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import Foundation

enum UsernamePersistence {
    private static let usernameKey = "cineaste-username"

    static var username: String? {
        get {
            return UserDefaults.standard.string(forKey: usernameKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: usernameKey)
        }
    }
}
