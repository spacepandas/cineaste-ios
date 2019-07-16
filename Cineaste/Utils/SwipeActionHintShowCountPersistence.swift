//
//  SwipeActionHintShowCountPersistence.swift
//  Cineaste App
//
//  Created by Wolfgang Timme on 7/15/19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import Foundation

enum SwipeActionHintShowCountPersistence {
    private static let swipeActionHintShowCountKey = "cineaste-swipeActionHintShowCount"

    /// The number of times that the "Swipe Action" hint of the movie cells has been shown.
    static var swipeActionHintShowCount: Int {
        get { return UserDefaults.standard.integer(forKey: swipeActionHintShowCountKey) }
        set { UserDefaults.standard.set(newValue, forKey: swipeActionHintShowCountKey) }
    }
}
