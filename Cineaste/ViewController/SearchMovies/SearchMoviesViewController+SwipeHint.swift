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

        cell.animateSwipeHint()
    }
}
