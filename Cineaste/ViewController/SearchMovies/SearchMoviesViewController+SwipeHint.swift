//
//  SearchMoviesViewController+SwipeHint.swift
//  Cineaste App
//
//  Created by Wolfgang Timme on 7/14/19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import UIKit

extension SearchMoviesViewController {
    /// Shows a hint for the swipe actions of the table view cells.
    func animateSwipeActionHint() {
        guard let cell = tableView.visibleCells.first as? SearchMoviesCell else { return }

        guard shouldAnimateShowSwipeActionHint else { return }

        cell.animateSwipeHint()

        rememberThatSwipeActionHintWasAnimated()
    }

    /// MARK: Persistency

    private var swipeActionHintShowCountKey: String {
        return "cineaste-swipeActionHintShowCount"
    }

    /// Determines whether the swipe action hint should be animated.
    private var shouldAnimateShowSwipeActionHint: Bool {
        let maximumNumberOfTimesToShowHint = 3
        let numberOfTimesHintWasShown = UserDefaults.standard.integer(forKey: swipeActionHintShowCountKey)

        return numberOfTimesHintWasShown < maximumNumberOfTimesToShowHint
    }

    private func rememberThatSwipeActionHintWasAnimated() {
        let numberOfTimesHintWasShown = UserDefaults.standard.integer(forKey: swipeActionHintShowCountKey)

        UserDefaults.standard.set(numberOfTimesHintWasShown + 1, forKey: swipeActionHintShowCountKey)
    }
}
