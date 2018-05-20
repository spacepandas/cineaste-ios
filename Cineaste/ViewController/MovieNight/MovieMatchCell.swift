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

        seenButton.setTitle(Strings.startMovieNight, for: .normal)
        nearbyMovie = movieWithOccurance
        movieTitelLabel.text = movieWithOccurance.nearbyMovie.title
        seenButton.addTarget(self, action: #selector(startMovienightButtonTouched(_:)), for: .touchUpInside)

        loadPoster(for: movieWithOccurance.nearbyMovie) { poster in
            DispatchQueue.main.async {
                self.posterToDisplay = poster
                self.posterImageView.image = self.posterToDisplay ?? Images.posterPlaceholder
            }
        }

        numberOfMatchesLabel.text = Strings.matches(for: movieWithOccurance.occurances,
                                                    amountOfPeople: amountOfPeople)
    }

    fileprivate func loadPoster(for movie: NearbyMovie, completionHandler handler: @escaping (_ poster: UIImage?) -> Void) {
        guard let posterPath = movie.posterPath else {
            return
        }
        Webservice.load(resource: Movie.loadPoster(from: posterPath)) { result in
            guard case let .success(image) = result else {
                handler(nil)
                return
            }
            handler(image)
        }
    }

    // MARK: - Actions

    @objc
    func startMovienightButtonTouched(_ sender: UIButton) {
        guard let nearbyMovie = nearbyMovie else {
            fatalError("Nearbymovie must be set for starting a movienight")
        }
        delegate?.movieMatchTableViewCell(sender: self, didSelectMovie: nearbyMovie, withPoster: posterToDisplay)
    }
}
