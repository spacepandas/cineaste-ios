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

    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var separatorView: UIView!

    @IBOutlet private weak var movieTitelLabel: UILabel!
    @IBOutlet private weak var numberOfMatchesLabel: UILabel!
    @IBOutlet private weak var seenButton: UIButton!

    private var nearbyMovie: NearbyMovie?
    private weak var delegate: MovieMatchTableViewCellDelegate?

    private func setup(with movie: NearbyMovie,
                       delegate: MovieMatchTableViewCellDelegate) {
        self.delegate = delegate

        seenButton.setTitle(.watchNow, for: .normal)
        nearbyMovie = movie
        movieTitelLabel.text = movie.title
        seenButton.addTarget(self,
                             action: #selector(startMovieNightButtonTouched),
                             for: .touchUpInside)

        if let posterPath = movie.posterPath {
            let posterUrl = Movie.posterUrl(from: posterPath, for: .small)
            posterImageView.kf.setImage(with: posterUrl,
                                        placeholder: UIImage.posterPlaceholder)
        } else {
            posterImageView.image = UIImage.posterPlaceholder
        }
    }

    func configure(with movie: NearbyMovie,
                   numberOfMatches: Int,
                   amountOfPeople: Int,
                   delegate: MovieMatchTableViewCellDelegate) {
        setup(with: movie, delegate: delegate)

        numberOfMatchesLabel.isHidden = false
        let matches = String.matches(for: numberOfMatches,
                                     amountOfPeople: amountOfPeople)
        numberOfMatchesLabel.text = matches

        applyAccessibility(for: movie, numberOfMatches: matches)
    }

    func configure(with movie: NearbyMovie,
                   delegate: MovieMatchTableViewCellDelegate) {
        setup(with: movie, delegate: delegate)

        numberOfMatchesLabel.isHidden = true

        applyAccessibility(for: movie, numberOfMatches: nil)
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

        delegate?.movieMatchTableViewCell(didSelectMovie: nearbyMovie,
                                          withPoster: posterImageView.image)
    }
}
