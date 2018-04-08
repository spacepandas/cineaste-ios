//
//  MovieMatchTableViewCell.swift
//  Cineaste
//
//  Created by Christian Braun on 26.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

protocol MovieMatchTableViewCellDelegate: class {
    func movieMatchTableViewCell(sender: MovieMatchTableViewCell, didSelectMovie selectedMovie: NearbyMovieWithOccurrence, withPoster poster: UIImage?)
}

class MovieMatchTableViewCell: UITableViewCell {
    static let cellIdentifier = "MovieMatchTableViewCell"
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitelLabel: UILabel!
    @IBOutlet weak var numberOfMatchesLabel: UILabel!
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

        numberOfMatchesLabel.text = "\(movieWithOccurance.occurances) of \(amountOfPeople)"
    }

    fileprivate func loadPoster(for movie: NearbyMovie, completionHandler handler: @escaping (_ poster: UIImage?) -> Void) {
        guard let posterPath = movie.posterPath else {
            return
        }
        Webservice.load(resource: Movie.loadPoster(path: posterPath)) { result in
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
