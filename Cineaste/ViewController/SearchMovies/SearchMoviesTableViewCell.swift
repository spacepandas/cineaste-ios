//
//  SearchMoviesTableViewCell.swift
//  Cineaste
//
//  Created by Christian Braun on 02.11.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

class SearchMoviesTableViewCell: UITableViewCell {
    static let CELL_IDENTIFIER = "SearchMoviesTableViewCell"
    @IBOutlet weak fileprivate var posterImageView: UIImageView!
    @IBOutlet weak fileprivate var movieTitleLabel: UILabel!
    
    var movie:Movie? {
        didSet {
            movieTitleLabel.text = movie?.title
            loadAndSetPoster()
        }
    }

    fileprivate func loadAndSetPoster() {
        guard let movie = movie else { return }
        Webservice.load(resource: movie.loadPoster()) {image, error in
            DispatchQueue.main.async {
                self.posterImageView.image = image
                self.movie?.poster = image
            }
        }
    }

}
