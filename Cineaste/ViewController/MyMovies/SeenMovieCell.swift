//
//  SeenMovieCell.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 12.05.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class SeenMovieCell: UITableViewCell {
    static let identifier = "SeenMovieCell"

    @IBOutlet var poster: UIImageView!
    @IBOutlet var title: TitleLabel!
    @IBOutlet var separatorView: UIView! {
        didSet {
            separatorView.backgroundColor = .primaryOrange
        }
    }
    @IBOutlet var watched: DescriptionLabel!
    @IBOutlet var watchedIcon: UIImageView! {
        didSet {
            watchedIcon.tintColor = UIColor.accentText
        }
    }

    func configure(with movie: StoredMovie) {
        if let moviePoster = movie.poster {
            poster.image = UIImage(data: moviePoster)
        } else {
            poster.image = UIImage.posterPlaceholder
        }

        title.text = movie.title
        watched.text = movie.formattedWatchedDate
    }
}
