//
//  SearchMoviesCell.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 02.03.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import UIKit

class SearchMoviesCell: UITableViewCell {
    static let identifier = "SearchMoviesCell"

    enum WatchState {
        case normal
        case seen
        case watchlist
    }

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: TitleLabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var detailLabel: DescriptionLabel!
    @IBOutlet weak var stateImageView: UIImageView!

    // MARK: - Actions

    func configure(with movie: Movie, state: WatchState) {
        title.text = movie.title
        detailLabel.text = movie.formattedReleaseYear
        //TODO: load runtime for movies
//            + " ∙ "
//            + movie.formattedRuntime

        switch state {
        case .normal:
            stateImageView.isHidden = true
        case .seen:
            stateImageView.isHidden = false
            stateImageView.image = #imageLiteral(resourceName: "seen-badge")
        case .watchlist:
            stateImageView.isHidden = false
            stateImageView.image = #imageLiteral(resourceName: "watchlist-badge")
        }

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
