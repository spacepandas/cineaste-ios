//
//  SearchMoviesCell.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 02.03.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import UIKit

class SearchMoviesCell: UITableViewCell {
    static let identifier = "SearchMoviesCell"

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var stateImageView: UIImageView!
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var soonHint: HintView!
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var swipeHintView: UIView! {
        didSet {
            swipeHintView.backgroundColor = SwipeAction.moveToWatchlist.backgroundColor
        }
    }

    // MARK: - Actions

    func animateSwipeHint() {
        cellBackgroundView.slideIn(from: .trailing)
    }

    func configure(with movie: Movie, state: WatchState) {
        cellBackgroundView.backgroundColor = .cineCellBackground

        poster.accessibilityIgnoresInvertColors = true
        let nonbreakingSpace = "\u{00a0}"
        title.text = movie.title
        detailLabel.text = movie.formattedRelativeReleaseInformation
            + " ∙ "
            + movie.formattedVoteAverage
            + "\(nonbreakingSpace)/\(nonbreakingSpace)10"

        soonHint.content = .soonReleaseInformation
        soonHint.isHidden = !movie.soonAvailable
        placeholderView.isHidden = !movie.soonAvailable

        switch state {
        case .undefined:
            stateImageView.isHidden = true
        case .seen:
            stateImageView.isHidden = false
            stateImageView.image = #imageLiteral(resourceName: "seen-badge")
        case .watchlist:
            stateImageView.isHidden = false
            stateImageView.image = #imageLiteral(resourceName: "watchlist-badge")
        }

        poster.loadingImage(from: movie.posterPath, in: .small)

        applyAccessibility(with: movie, for: state)
    }

    private func applyAccessibility(with movie: Movie, for state: WatchState) {
        let isSoonAvailable = !soonHint.isHidden
        let voting = String.voting(for: movie.formattedVoteAverage)

        isAccessibilityElement = true

        accessibilityLabel = movie.title
        if let state = String.state(for: state) {
            accessibilityLabel?.append(", \(state)")
        }
        accessibilityLabel?.append(", \(voting)")
        accessibilityLabel?.append(isSoonAvailable ? ", \(String.soonReleaseInformationLong)" : "")
        accessibilityLabel?.append(", \(movie.formattedRelativeReleaseInformation)")
    }
}
