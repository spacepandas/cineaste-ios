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

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var watchedDateLabel: UILabel!

    func configure(with movie: Movie) {
        if let moviePoster = movie.poster {
            poster.image = moviePoster
        } else {
            poster.image = UIImage.posterPlaceholder
        }

        title.text = movie.title
        watchedDateLabel.text = movie.formattedWatchedDate

        applyAccessibility(with: movie)
    }

    private func applyAccessibility(with movie: Movie) {
        isAccessibilityElement = true

        accessibilityLabel = movie.title
        if let watchedDate = movie.formattedWatchedDate {
            accessibilityLabel?.append(", \(watchedDate)")
        }
    }
}
