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
    @IBOutlet var title: UILabel!
    @IBOutlet var separatorView: UIView! {
        didSet {
            separatorView.backgroundColor = .primaryOrange
        }
    }

    @IBOutlet var releaseDate: DescriptionLabel!

    @IBOutlet weak fileprivate var seenButton: ActionButton! {
        didSet {
            let title = NSLocalizedString("Schon gesehen", comment: "Title for seen movie button")
            self.seenButton.setTitle(title, for: .normal)
        }
    }

    @IBOutlet weak fileprivate var mustSeeButton: ActionButton! {
        didSet {
            let title = NSLocalizedString("Muss ich sehen", comment: "Title for must see movie button")
            self.mustSeeButton.setTitle(title, for: .normal)
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
        releaseDate.text = movie.releaseDate.formatted

        loadPoster(for: movie) { poster in
            DispatchQueue.main.async {
                movie.poster = poster
                self.poster.image = poster
            }
        }
    }

    fileprivate func loadPoster(for movie: Movie, completionHandler handler: @escaping (_ poster: UIImage?) -> Void) {
        Webservice.load(resource: movie.loadPoster()) { result in
            guard case let .success(image) = result else {
                // TODO: We should handle the error
                return
            }
            handler(image)
        }
    }
}
