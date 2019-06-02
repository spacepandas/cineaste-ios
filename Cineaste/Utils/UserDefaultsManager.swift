//
//  UserDefaultsManager.swift
//  Cineaste
//
//  Created by Christian Braun on 21.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import Foundation

enum UserDefaultsManager {
    static var username: String? {
        get {
            return UserDefaults.standard
                .string(forKey: Constants.UserDefaults.usernameKey)
        }
        set {
            UserDefaults.standard
                .set(newValue, forKey: Constants.UserDefaults.usernameKey)
        }
    }
}
