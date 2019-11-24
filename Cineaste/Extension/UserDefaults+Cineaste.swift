//
//  UserDefaults+Cineaste.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 24.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import Foundation

private let lastVersionPromptedForReviewKey = "cineaste-lastVersionPromtedForReview"
private let processCompletedCountKey = "cineaste-processCompletedCount"
private let swipeActionHintShowCountKey = "cineaste-swipeActionHintShowCount"
private let usernameKey = "cineaste-username"

extension UserDefaults {

    /// The last version an appstore review has promted
    var lastVersionPromptedForReview: String? {
        get { return string(forKey: lastVersionPromptedForReviewKey) }
        set { set(newValue, forKey: lastVersionPromptedForReviewKey) }
    }

    /// The counter how often it could be asked for an appstore review
    var processCompletedCount: Int {
        get { return integer(forKey: processCompletedCountKey) }
        set { set(newValue, forKey: processCompletedCountKey) }
    }

    /// The number of times that the "Swipe Action" hint of the movie cells has been shown
    var swipeActionHintShowCount: Int {
        get { return integer(forKey: swipeActionHintShowCountKey) }
        set { set(newValue, forKey: swipeActionHintShowCountKey) }
    }

    /// The name of the user
    var username: String? {
        get {
            let username = string(forKey: usernameKey) ?? ""
            return username.isEmpty ? nil : username
        }
        set { set(newValue, forKey: usernameKey) }
    }

}
