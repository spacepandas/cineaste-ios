//
//  MovieDetailViewController.swift
//  Cineaste
//
//  Created by Christian Braun on 04.11.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit
import CoreData

class MovieDetailViewController: UIViewController {
    @IBOutlet weak fileprivate var posterImageView: UIImageView!

    @IBOutlet weak fileprivate var titleLabel: TitleLabel!

    @IBOutlet var descriptionLabels: [DescriptionLabel]! {
        didSet {
            for label in descriptionLabels {
                label.textColor = UIColor.basicBackground
            }
        }
    }
    @IBOutlet weak fileprivate var releaseDateLabel: DescriptionLabel!
    @IBOutlet weak fileprivate var runtimeLabel: DescriptionLabel!
    @IBOutlet weak fileprivate var votingLabel: DescriptionLabel! {
        didSet {
            votingLabel.textColor = UIColor.black
        }
    }

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

    @IBOutlet weak fileprivate var descriptionTextView: UITextView!

    let storageManager = MovieStorageManager()

    var movie: Movie? {
        didSet {
            DispatchQueue.main.async {
                self.posterImageView.image = self.movie?.poster
                self.titleLabel.text = self.movie?.title
                self.descriptionTextView.text = self.movie?.overview
                if let movie = self.movie {
                    self.runtimeLabel.text = "\(movie.runtime) min"
                    self.votingLabel.text = "\(movie.voteAverage)"
                    self.releaseDateLabel.text = movie.releaseDate.formatted
                }
            }
        }
    }

    var storedMovie: StoredMovie? {
        didSet {
            guard let movie = self.storedMovie else { return }
            DispatchQueue.main.async {
                if let moviePoster = movie.poster {
                    self.posterImageView.image = UIImage(data: moviePoster)
                }
                self.titleLabel.text = movie.title
                self.descriptionTextView.text = movie.overview
                self.runtimeLabel.text = "\(movie.runtime) min"
                self.votingLabel.text = "\(movie.voteAverage)"
                self.releaseDateLabel.text = movie.releaseDate?.formatted
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.isEditable = false
        loadMovie()
    }

    // MARK: - Private

    fileprivate func loadMovie() {
        guard let movie = movie else {
            return
        }
        Webservice.load(resource: movie.get) {[weak self] movie, _ in
            movie?.poster = self?.movie?.poster
            self?.movie = movie
        }
    }
    // MARK: - Actions

    @IBAction func mustSeeButtonTouched(_ sender: UIButton) {
        saveMovie(withWatched: false)
    }

    @IBAction func seenButtonTouched(_ sender: UIButton) {
        saveMovie(withWatched: true)
    }

    // MARK: - Private

    fileprivate func saveMovie(withWatched watched: Bool) {
        guard let movie = movie else { return }
        storageManager.insertMovieItem(with: movie, watched: watched) { _ in
            // TODO: We should definitely show an error when insertion failed
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

}

extension MovieDetailViewController: Instantiable {
    static var storyboard: Storyboard { return .movieDetail }
    static var storyboardID: String? { return "MovieDetailViewController" }
}
