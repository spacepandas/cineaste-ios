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

extension UserDefaults {

    /// The last version an AppStore review has prompted
    var lastVersionPromptedForReview: String? {
        get { string(forKey: lastVersionPromptedForReviewKey) }
        set { set(newValue, forKey: lastVersionPromptedForReviewKey) }
    }

    /// The counter how often it could be asked for an AppStore review
    var processCompletedCount: Int {
        get { integer(forKey: processCompletedCountKey) }
        set { set(newValue, forKey: processCompletedCountKey) }
    }

    /// The number of times that the "Swipe Action" hint of the movie cells has been shown
    var swipeActionHintShowCount: Int {
        get { integer(forKey: swipeActionHintShowCountKey) }
        set { set(newValue, forKey: swipeActionHintShowCountKey) }
    }

}
