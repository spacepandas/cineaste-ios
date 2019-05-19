//
//  WatchlistCell.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 06.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

class WatchlistMovieCell: UITableViewCell {
    static let identifier = "WatchlistMovieCell"

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var releaseAndRuntimeLabel: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var voteView: VoteView!

    func configure(with movie: Movie) {
        let nonbreakingSpace = "\u{00a0}"

        if let posterPath = movie.posterPath {
            poster.kf.indicatorType = .activity
            let posterUrl = Movie.posterUrl(from: posterPath, for: .small)
            poster.kf.setImage(with: posterUrl, placeholder: UIImage.posterPlaceholder)
        } else {
            poster.image = UIImage.posterPlaceholder
        }

        releaseAndRuntimeLabel.text = movie.formattedRelativeReleaseInformation
            + " ∙ "
            + movie.formattedRuntime

        title.text = movie.title
        voteView.content = movie.formattedVoteAverage
            + "\(nonbreakingSpace)/\(nonbreakingSpace)10"

        applyAccessibility(with: movie)
    }

    private func applyAccessibility(with movie: Movie) {
        isAccessibilityElement = true

        accessibilityLabel = movie.title

        let voting = String.voting(for: movie.formattedVoteAverage)
        accessibilityLabel?.append(", \(voting)")

        accessibilityLabel?.append(", \(movie.formattedRelativeReleaseInformation)")
        accessibilityLabel?.append(", \(movie.formattedRuntime)")
    }
}
