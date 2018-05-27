//
//  SearchMoviesTableViewCell.swift
//  Cineaste
//
//  Created by Christian Braun on 02.11.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

protocol SearchMoviesCellDelegate: class {
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

    @IBOutlet var poster: UIImageView!
    @IBOutlet var title: TitleLabel!
    @IBOutlet var separatorView: UIView! {
        didSet {
            separatorView.backgroundColor = .primaryOrange
        }
    }

    @IBOutlet var releaseDate: DescriptionLabel!

    @IBOutlet weak var seenButton: ActionButton! {
        didSet {
            self.seenButton.setTitle(String.seenButton, for: .normal)
        }
    }

    @IBOutlet weak var mustSeeButton: ActionButton! {
        didSet {
            self.mustSeeButton.setTitle(String.wantToSeeButton, for: .normal)
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

        loadPoster(for: movie) { poster in
            DispatchQueue.main.async {
                let posterToDisplay = poster ?? UIImage.posterPlaceholder

                movie.poster = posterToDisplay
                self.poster.image = posterToDisplay
            }
        }
    }

    fileprivate func loadPoster(for movie: Movie, completionHandler handler: @escaping (_ poster: UIImage?) -> Void) {
        guard let posterPath = movie.posterPath else {
            handler(nil)
            return
        }

        Webservice.load(resource: Movie.loadPoster(from: posterPath)) { result in
            guard case let .success(image) = result else {
                handler(nil)
                return
            }
            handler(image)
        }
    }
}
