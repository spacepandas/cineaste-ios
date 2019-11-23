//
//  MovieMatchTableViewCell.swift
//  Cineaste
//
//  Created by Christian Braun on 26.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

protocol MovieMatchTableViewCellDelegate: AnyObject {
    func movieMatchTableViewCell(didSelectMovie movie: NearbyMovie, withPoster poster: UIImage?)
}

class MovieMatchCell: UITableViewCell {
    static let identifier = "MovieMatchCell"

    @IBOutlet private weak var background: UIView!
    @IBOutlet private weak var posterImageView: UIImageView!

    @IBOutlet private weak var movieTitelLabel: UILabel!
    @IBOutlet private weak var numberOfMatchesLabel: UILabel!
    @IBOutlet private weak var seenButton: UIButton!

    private var nearbyMovie: NearbyMovie?
    private weak var delegate: MovieMatchTableViewCellDelegate?

    func configure(with movie: NearbyMovie, numberOfMatches: Int, amountOfPeople: Int, delegate: MovieMatchTableViewCellDelegate) {
        setup(with: movie, delegate: delegate)

        numberOfMatchesLabel.isHidden = false
        let matches = String.matches(
            for: numberOfMatches,
            amountOfPeople: amountOfPeople)
        numberOfMatchesLabel.text = matches

        applyAccessibility(for: movie, numberOfMatches: matches)
    }

    func configure(with movie: NearbyMovie, delegate: MovieMatchTableViewCellDelegate) {
        setup(with: movie, delegate: delegate)

        numberOfMatchesLabel.isHidden = true

        applyAccessibility(for: movie, numberOfMatches: nil)
    }

    // MARK: custom functions

    private func setup(with movie: NearbyMovie, delegate: MovieMatchTableViewCellDelegate) {
        self.delegate = delegate
        nearbyMovie = movie

        background.backgroundColor = .cineCellBackground
        seenButton.setTitle(.chooseMovie, for: .normal)
        seenButton.accessibilityIdentifier = "Choose.Movie.Button"
        movieTitelLabel.text = movie.title
        seenButton.addTarget(
            self,
            action: #selector(startMovieNightButtonTouched),
            for: .touchUpInside)

        posterImageView.loadingImage(from: movie.posterPath, in: .small)
    }

    private func applyAccessibility(for movie: NearbyMovie, numberOfMatches: String?) {
        isAccessibilityElement = true

        accessibilityLabel = movie.title

        if let matches = numberOfMatches {
            accessibilityLabel?.append(", \(matches)")
        }
    }

    // MARK: - Actions

    @objc
    func startMovieNightButtonTouched() {
        guard let nearbyMovie = nearbyMovie else { return }

        delegate?.movieMatchTableViewCell(
            didSelectMovie: nearbyMovie,
            withPoster: posterImageView.image)
    }
}
