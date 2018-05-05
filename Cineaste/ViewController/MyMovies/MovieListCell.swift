//
//  MovieListCell.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 06.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

class MovieListCell: UITableViewCell {
    static let identifier = "MovieListCell"

    @IBOutlet var poster: UIImageView!
    @IBOutlet var title: TitleLabel!
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
        } else {
            poster.image = Images.posterPlaceholder
        }

        title.text = movie.title
        votes.text = movie.formattedVoteAverage
        runtime.text = movie.formattedRuntime
        releaseDate.text = movie.formattedReleaseDate
    }
}
