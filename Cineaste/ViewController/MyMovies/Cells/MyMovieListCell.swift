//
//  MovieListCell.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 06.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

class MyMovieListCell: UITableViewCell {
    static let identifier = "MyMovieListCell"

    @IBOutlet var poster: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var separatorView: UIView! {
        didSet {
            separatorView.backgroundColor = .primaryOrange
        }
    }

    @IBOutlet var votes: DescriptionLabel!
    @IBOutlet var runtime: DescriptionLabel!
    @IBOutlet var releaseDate: DescriptionLabel!

    func configure(with movie: StoredMovie) {
        if let moviePoster = movie.poster {
            poster.image = UIImage(data: moviePoster)
        }
        title.text = movie.title
        votes.text = "\(movie.voteAverage)"
        runtime.text = "\(movie.runtime) min"
        releaseDate.text = "\(movie.releaseDate?.formatted ?? Date().formatted)"
    }
}
