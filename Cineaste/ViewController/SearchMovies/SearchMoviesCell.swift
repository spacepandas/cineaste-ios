//
//  SearchMoviesTableViewCell.swift
//  Cineaste
//
//  Created by Christian Braun on 02.11.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

protocol SearchMoviesCellDelegate: AnyObject {
    func searchMoviesCell(didTriggerActionButtonFor movie: Movie, watched: Bool)
}

class SearchMoviesCell: UITableViewCell {
    static let identifier = "SearchMoviesCell"

    weak var delegate: SearchMoviesCellDelegate?

    var movie: Movie? {
        didSet {
            if let movie = movie {
                configure(with: movie)
            }
        }
    }

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: TitleLabel!
    @IBOutlet weak var separatorView: UIView! {
        didSet {
            separatorView.backgroundColor = .primaryOrange
        }
    }

    @IBOutlet weak var releaseDate: DescriptionLabel!

    @IBOutlet weak var seenButton: ActionButton! {
        didSet {
            seenButton.setTitle(String.seenAction, for: .normal)
        }
    }

    @IBOutlet weak var mustSeeButton: ActionButton! {
        didSet {
            mustSeeButton.setTitle(String.watchlistAction, for: .normal)
        }
    }

    // MARK: - Actions

    @IBAction func mustSeeButtonTouched(_ sender: UIButton) {
        guard let movie = movie else { return }
        delegate?.searchMoviesCell(didTriggerActionButtonFor: movie, watched: false)
    }

    @IBAction func seenButtonTouched(_ sender: UIButton) {
        guard let movie = movie else { return }
        delegate?.searchMoviesCell(didTriggerActionButtonFor: movie, watched: true)
    }

    func configure(with movie: Movie) {
        title.text = movie.title
        releaseDate.text = movie.formattedReleaseDate

        if let posterPath = movie.posterPath {
            poster.kf.indicatorType = .activity
            let posterUrl = Movie.posterUrl(from: posterPath, for: .small)
            poster.kf.setImage(with: posterUrl, placeholder: UIImage.posterPlaceholder) { result in
                if let image = result.value?.image {
                    movie.poster = image
                }
            }
        } else {
            poster.image = UIImage.posterPlaceholder
        }
    }
}
