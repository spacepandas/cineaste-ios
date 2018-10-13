//
//  MovieMatchTableViewCell.swift
//  Cineaste
//
//  Created by Christian Braun on 26.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

protocol MovieMatchTableViewCellDelegate: AnyObject {
    func movieMatchTableViewCell(sender: MovieMatchCell, didSelectMovie movie: NearbyMovie, withPoster poster: UIImage?)
}

class MovieMatchCell: UITableViewCell {
    static let identifier = "MovieMatchTableViewCell"

    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var separatorView: UIView! {
        didSet {
            separatorView.backgroundColor = .primaryOrange
        }
    }

    @IBOutlet private weak var movieTitelLabel: TitleLabel!
    @IBOutlet private weak var numberOfMatchesLabel: DescriptionLabel!
    @IBOutlet private weak var seenButton: ActionButton!

    private var nearbyMovie: NearbyMovie?
    private weak var delegate: MovieMatchTableViewCellDelegate?

    func configure(with movie: NearbyMovie,
                   numberOfMatches: Int,
                   amountOfPeople: Int,
                   delegate: MovieMatchTableViewCellDelegate) {
        self.delegate = delegate

        seenButton.setTitle(.startMovieNight, for: .normal)
        nearbyMovie = movie
        movieTitelLabel.text = movie.title
        seenButton.addTarget(self,
                             action: #selector(startMovieNightButtonTouched(_:)),
                             for: .touchUpInside)

        if let posterPath = movie.posterPath {
            let posterUrl = Movie.posterUrl(from: posterPath, for: .small)
            posterImageView.kf.setImage(with: posterUrl,
                                        placeholder: UIImage.posterPlaceholder)
        } else {
            posterImageView.image = UIImage.posterPlaceholder
        }

        numberOfMatchesLabel.text = String.matches(for: numberOfMatches,
                                                   amountOfPeople: amountOfPeople)
    }

    // MARK: - Actions

    @objc
    func startMovieNightButtonTouched(_ sender: UIButton) {
        guard let nearbyMovie = nearbyMovie else { return }

        delegate?.movieMatchTableViewCell(sender: self,
                                          didSelectMovie: nearbyMovie,
                                          withPoster: posterImageView.image)
    }
}
