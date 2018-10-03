//
//  MovieMatchTableViewCell.swift
//  Cineaste
//
//  Created by Christian Braun on 26.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

protocol MovieMatchTableViewCellDelegate: class {
    func movieMatchTableViewCell(sender: MovieMatchCell, didSelectMovie selectedMovie: NearbyMovieWithOccurrence, withPoster poster: UIImage?)
}

class MovieMatchCell: UITableViewCell {
    static let identifier = "MovieMatchTableViewCell"

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var separatorView: UIView! {
        didSet {
            separatorView.backgroundColor = .primaryOrange
        }
    }

    @IBOutlet weak var movieTitelLabel: TitleLabel!
    @IBOutlet weak var numberOfMatchesLabel: DescriptionLabel!
    @IBOutlet weak var seenButton: ActionButton!

    fileprivate var posterToDisplay: UIImage?

    fileprivate var nearbyMovie: NearbyMovieWithOccurrence?
    fileprivate weak var delegate: MovieMatchTableViewCellDelegate?

    func configure(with movieWithOccurance: NearbyMovieWithOccurrence,
                   amountOfPeople: Int,
                   delegate: MovieMatchTableViewCellDelegate) {
        self.delegate = delegate

        seenButton.setTitle(.startMovieNight, for: .normal)
        nearbyMovie = movieWithOccurance
        movieTitelLabel.text = movieWithOccurance.nearbyMovie.title
        seenButton.addTarget(self,
                             action: #selector(startMovienightButtonTouched(_:)),
                             for: .touchUpInside)

        if let posterPath = movieWithOccurance.nearbyMovie.posterPath {
            let posterUrl = Movie.posterUrl(from: posterPath, for: .small)
            posterImageView.kf.setImage(with: posterUrl,
                                        placeholder: UIImage.posterPlaceholder)
        } else {
            posterImageView.image = UIImage.posterPlaceholder
        }

        numberOfMatchesLabel.text = String.matches(for: movieWithOccurance.occurances,
                                                    amountOfPeople: amountOfPeople)
    }

    // MARK: - Actions

    @objc
    func startMovienightButtonTouched(_ sender: UIButton) {
        guard let nearbyMovie = nearbyMovie else {
            fatalError("Nearbymovie must be set for starting a movienight")
        }
        delegate?.movieMatchTableViewCell(sender: self,
                                          didSelectMovie: nearbyMovie,
                                          withPoster: posterToDisplay)
    }
}
