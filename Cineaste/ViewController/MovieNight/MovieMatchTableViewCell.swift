//
//  MovieMatchTableViewCell.swift
//  Cineaste
//
//  Created by Christian Braun on 26.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class MovieMatchTableViewCell: UITableViewCell {
    static let cellIdentifier = "MovieMatchTableViewCell"
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitelLabel: UILabel!
    @IBOutlet weak var numberOfMatchesLabel: UILabel!
    @IBOutlet weak var seenButton: ActionButton!

    func configure(with movieWithOccurance: NearbyMovieWithOccurrence, amountOfPeople: Int) {
        movieTitelLabel.text = movieWithOccurance.nearbyMovie.title

        loadPoster(for: movieWithOccurance.nearbyMovie) { poster in
            DispatchQueue.main.async {
                let posterToDisplay = poster ?? Images.posterPlaceholder
                self.posterImageView.image = posterToDisplay
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
}
