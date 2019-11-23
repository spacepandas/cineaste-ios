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

    func configure(with movie: Movie) {
        background.backgroundColor = .cineCellBackground

        poster.accessibilityIgnoresInvertColors = true
        poster.loadingImage(from: movie.posterPath, in: .small)

        title.text = movie.title

        watchedDateLabel.text = movie.formattedWatchedDate

        applyAccessibility(for: movie)
    }

    private func applyAccessibility(for movie: Movie) {
        isAccessibilityElement = true

        accessibilityLabel = movie.title

        if let watchedDate = movie.formattedWatchedDate {
            accessibilityLabel?.append(", \(watchedDate)")
        }
    }
}
