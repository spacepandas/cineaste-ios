//
//  PromtForReviewPersistence.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 10.06.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import Foundation

enum PromtForReviewPersistence {
    private static let lastVersionPromptedForReviewKey = "cineaste-lastVersionPromtedForReview"
    private static let processCompletedCountKey = "cineaste-processCompletedCount"

    static var lastVersionPromptedForReview: String? {
        get { return UserDefaults.standard.string(forKey: lastVersionPromptedForReviewKey) }
        set { UserDefaults.standard.set(newValue, forKey: lastVersionPromptedForReviewKey) }
    }

    static var processCompletedCount: Int {
        get { return UserDefaults.standard.integer(forKey: processCompletedCountKey) }
        set { UserDefaults.standard.set(newValue, forKey: processCompletedCountKey) }
    }
}
