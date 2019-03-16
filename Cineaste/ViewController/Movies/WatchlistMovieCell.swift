//
//  WatchlistCell.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 06.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

class WatchlistMovieCell: UITableViewCell {
    static let identifier = "WatchlistMovieCell"

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var releaseAndRuntimeLabel: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var voteView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!

    func configure(with movie: StoredMovie) {
        if let moviePoster = movie.poster {
            poster.image = UIImage(data: moviePoster)
        } else {
            poster.image = UIImage.posterPlaceholder
        }

        releaseAndRuntimeLabel.text = movie.formattedRelativeReleaseInformation
            + " ∙ "
            + movie.formattedRuntime

        title.text = movie.title

        //TODO: add voteView
        voteView.isHidden = true

        //TODO: add category
        categoryLabel.isHidden = true
//        categoryLabel.text = movie.category
    }
}
