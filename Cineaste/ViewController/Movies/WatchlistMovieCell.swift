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

    @IBOutlet weak var background: UIView!

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var releaseAndRuntimeLabel: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var voteView: VoteView!

    func configure(with movie: StoredMovie) {
        background.backgroundColor = .cineCellBackground
        let nonbreakingSpace = "\u{00a0}"

        if let moviePoster = movie.poster {
            poster.image = UIImage(data: moviePoster)
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

    private func applyAccessibility(with movie: StoredMovie) {
        isAccessibilityElement = true

        accessibilityLabel = movie.title

        let voting = String.voting(for: movie.formattedVoteAverage)
        accessibilityLabel?.append(", \(voting)")

        accessibilityLabel?.append(", \(movie.formattedRelativeReleaseInformation)")
        accessibilityLabel?.append(", \(movie.formattedRuntime)")
    }
}
