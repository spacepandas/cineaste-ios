//
//  SeenMovieCell.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 12.05.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class SeenMovieCell: UITableViewCell {
    static let identifier = "SeenMovieCell"

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var watchedDateLabel: UILabel!
    @IBOutlet weak var posterWidth: NSLayoutConstraint!

    func configure(with movie: Movie) {
        background.backgroundColor = .cineCellBackground

        poster.accessibilityIgnoresInvertColors = true
        poster.loadingImage(from: movie.posterPath, in: .small)

        title.text = movie.title

        watchedDateLabel.text = movie.formattedWatchedDate

        if #available(iOS 14.0, *) {
            backgroundConfiguration = UIBackgroundConfiguration.clear()
        }

        selectionStyle = .none
        updatePosterWidthIfNeeded()

        applyAccessibility(for: movie)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updatePosterWidthIfNeeded()
    }

    private func applyAccessibility(for movie: Movie) {
        isAccessibilityElement = true
        accessibilityTraits.insert(.button)

        accessibilityLabel = movie.title

        if let watchedDate = movie.formattedWatchedDate {
            accessibilityLabel?.append(", \(watchedDate)")
        }
    }

    private func updatePosterWidthIfNeeded() {
        guard let window = UIApplication.shared.keyWindow else { return }

        posterWidth = updateMultiplierOfConstraint(
            posterWidth,
            newMultiplier: window.sizeCategory.relativePosterSize
        )
    }
}
