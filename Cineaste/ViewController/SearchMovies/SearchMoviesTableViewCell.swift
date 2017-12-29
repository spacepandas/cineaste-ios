//
//  SearchMoviesTableViewCell.swift
//  Cineaste
//
//  Created by Christian Braun on 02.11.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

class SearchMoviesTableViewCell: UITableViewCell {
    static let identifier = "SearchMoviesTableViewCell"

    @IBOutlet weak fileprivate var posterImageView: UIImageView!
    @IBOutlet weak fileprivate var movieTitleLabel: UILabel!

    func configure(with movie: Movie) {
        movieTitleLabel.text = movie.title

        loadPoster(for: movie) { poster in
            DispatchQueue.main.async {
                movie.poster = poster
                self.posterImageView.image = poster
            }
        }
    }

    fileprivate func loadPoster(for movie: Movie, completionHandler handler: @escaping (_ poster: UIImage?) -> Void) {
        Webservice.load(resource: movie.loadPoster()) { image, _ in
            handler(image)
        }
    }
}
