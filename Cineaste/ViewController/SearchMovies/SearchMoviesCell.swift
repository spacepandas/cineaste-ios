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
    private weak var posterLoadingTask: URLSessionTask?
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
            seenButton.setTitle(String.seen, for: .normal)
        }
    }

    @IBOutlet weak var mustSeeButton: ActionButton! {
        didSet {
            mustSeeButton.setTitle(String.wantToSee, for: .normal)
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
        releaseDate.text = movie.formattedReleaseDate()
        poster.image = UIImage.posterPlaceholder

        guard let posterPath = movie.posterPath else { return }
        posterLoadingTask = Webservice.load(resource: Movie.loadPoster(from: posterPath)) { result in
            self.posterLoadingTask = nil
            guard case let .success(poster) = result else {
                return
            }

            DispatchQueue.main.async {
                movie.poster = poster
                self.poster.image = poster
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterLoadingTask?.cancel()
    }
}
