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
            self.seenButton.setTitle(Strings.seenButton, for: .normal)
        }
    }
    @IBOutlet weak fileprivate var mustSeeButton: ActionButton! {
        didSet {
            self.mustSeeButton.setTitle(Strings.mustSeeButton, for: .normal)
        }
    }

    @IBOutlet weak fileprivate var descriptionTextView: UITextView!

    var storageManager: MovieStorage?

    var movie: Movie?

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
        loadMovieDetailAndSetupUI()
    }

    // MARK: - Actions

    @IBAction func mustSeeButtonTouched(_ sender: UIButton) {
        saveMovie(withWatched: false)
    }

    @IBAction func seenButtonTouched(_ sender: UIButton) {
        saveMovie(withWatched: true)
    }

    // MARK: - Private

    fileprivate func setupUIWithNetworkMovie() {
        DispatchQueue.main.async {
            guard let movie = self.movie else { return }
            if let moviePoster = movie.poster {
                self.posterImageView.image = moviePoster
            }
            self.titleLabel.text = movie.title
            self.descriptionTextView.text = movie.overview
            self.runtimeLabel.text = "\(movie.runtime) min"
            self.votingLabel.text = "\(movie.voteAverage)"
            self.releaseDateLabel.text = movie.releaseDate.formatted
        }
    }

    fileprivate func saveMovie(withWatched watched: Bool) {
        guard let storageManager = storageManager else { return }
        if let movie = movie {
            storageManager.insertMovieItem(with: movie, watched: watched) { result in
                guard case .success = result else {
                    self.showAlert(withMessage: Alert.insertMovieError)
                    return
                }

                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        } else if let storedMovie = storedMovie {
            storageManager.updateMovieItem(with: storedMovie, watched: watched) { result in
                guard case .success = result else {
                    self.showAlert(withMessage: Alert.updateMovieError)
                    return
                }

                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    fileprivate func loadMovieDetailAndSetupUI() {
        guard let movie = movie else { return }
        // Setup with the default data to show something while new data is loading
        self.setupUIWithNetworkMovie()
        Webservice.load(resource: movie.get) { result in
            guard case let .success(detailedMovie) = result else {
                return
            }
            detailedMovie.poster = movie.poster
            self.movie = detailedMovie
            self.setupUIWithNetworkMovie()
        }
    }
}

extension MovieDetailViewController: Instantiable {
    static var storyboard: Storyboard { return .movieDetail }
    static var storyboardID: String? { return "MovieDetailViewController" }
}
