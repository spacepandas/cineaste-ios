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
            let username = UserDefaults.standard.string(forKey: usernameKey) ?? ""
            return username.isEmpty ? nil : username
        }
        set { UserDefaults.standard.set(newValue, forKey: usernameKey) }
    }
}
