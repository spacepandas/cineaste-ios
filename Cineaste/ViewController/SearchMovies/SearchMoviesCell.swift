//
//  SearchMoviesTableViewCell.swift
//  Cineaste
//
//  Created by Christian Braun on 02.11.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

class SearchMoviesCell: UITableViewCell {
    static let identifier = "SearchMoviesCell"

    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var movieTitleLabel: UILabel!

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
        Webservice.load(resource: movie.loadPoster()) { result in
            guard case let .success(image) = result else {
                handler(nil)
                return
            }
            handler(image)
        }
    }
}
