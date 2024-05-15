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
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var stateImageView: UIImageView!
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var soonHint: HintView!
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var swipeHintView: UIView!
    @IBOutlet weak var posterWidth: NSLayoutConstraint!
    @IBOutlet weak var stateImageWidth: NSLayoutConstraint!

    // MARK: - Actions

    func animateSwipeHint() {
        cellBackgroundView.slideIn(from: .trailing)
    }

    func configure(with movie: Movie) {
        cellBackgroundView.backgroundColor = .cineCellBackground
        swipeHintView.backgroundColor = SwipeAction.moveToWatchlist.backgroundColor
        poster.accessibilityIgnoresInvertColors = true
        poster.loadingImage(from: movie.posterPath, in: .small)
        title.text = movie.title
        soonHint.content = .soonReleaseInformation
        soonHint.isHidden = !movie.soonAvailable
        placeholderView.isHidden = !movie.soonAvailable

        let nonbreakingSpace = "\u{00a0}"
        detailLabel.text = movie.formattedRelativeReleaseInformation
            + " ∙ "
            + movie.formattedVoteAverage
            + "\(nonbreakingSpace)/\(nonbreakingSpace)10"

        switch movie.currentWatchState {
        case .undefined:
            stateImageView.isHidden = true
        case .seen:
            stateImageView.isHidden = false
            stateImageView.image = UIImage.seenBadgeIcon
        case .watchlist:
            stateImageView.isHidden = false
            stateImageView.image = UIImage.watchlistBadgeIcon
        }

        updatePosterWidthIfNeeded()
        updateStateImageWidthIfNeeded()

        applyAccessibility(for: movie)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updatePosterWidthIfNeeded()
        updateStateImageWidthIfNeeded()
    }

    private func applyAccessibility(for movie: Movie) {
        isAccessibilityElement = true
        accessibilityTraits.insert(.button)

        accessibilityLabel = movie.title

        let isSoonAvailable = !soonHint.isHidden
        let value = [
            String.state(for: movie.currentWatchState),
            String.votingAccessibilityLabel(for: movie.formattedVoteAverage),
            isSoonAvailable
                ? String.soonReleaseInformationLong
                : "",
            movie.accessibilityFormattedRelativeReleaseInformation
        ]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined(separator: ", ")

        accessibilityValue = value
    }

    private func updatePosterWidthIfNeeded() {
        guard let window = UIApplication.shared.keyWindow else { return }

        posterWidth = updateMultiplierOfConstraint(
            posterWidth,
            newMultiplier: window.sizeCategory.relativePosterSize
        )
    }

    private func updateStateImageWidthIfNeeded() {
        guard let window = UIApplication.shared.keyWindow else { return }

        stateImageWidth = updateMultiplierOfConstraint(
            stateImageWidth,
            newMultiplier: window.sizeCategory.relativeWatchStateImageSize
        )
    }
}
