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
    @IBOutlet weak fileprivate var runtimeLabel: UILabel!
    @IBOutlet weak fileprivate var votingLabel: UILabel!
    @IBOutlet weak fileprivate var seenButton: UIButton!
    @IBOutlet weak fileprivate var mustSeeButton: UIButton!
    @IBOutlet weak fileprivate var posterImageView: UIImageView!
    @IBOutlet weak fileprivate var titleLabel: UILabel!
    @IBOutlet weak fileprivate var descriptionTextView: UITextView!

    var movie: Movie? {
        didSet {
            DispatchQueue.main.async {
                self.posterImageView.image = self.movie?.poster
                self.titleLabel.text = self.movie?.title
                self.descriptionTextView.text = self.movie?.overview
                if let movie = self.movie {
                    self.runtimeLabel.text = "\(movie.runtime) m"
                    self.votingLabel.text = "\(movie.voteAverage)"
                }
            }
        }
    }

    var storedMovie: StoredMovie? {
        didSet {
            DispatchQueue.main.async {
//                self.posterImageView.image = self.storedMovie?.poster
                self.titleLabel.text = self.storedMovie?.title
                self.descriptionTextView.text = self.storedMovie?.overview
                if let movie = self.storedMovie {
//                    self.runtimeLabel.text = "\(movie.runtime) m"
                    self.votingLabel.text = "\(movie.voteAverage)"
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.isEditable = false
        styleButton(button: mustSeeButton)
        styleButton(button: seenButton)
        loadMovie()
    }

    func styleButton(button: UIButton) {
        button.layer.borderWidth = 1.0
        button.layer.borderColor = button.tintColor.cgColor
        button.layer.cornerRadius = 8
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
        guard let movie = movie else { return }
        AppDelegate.persistentContainer.performBackgroundTask { context in
            StoredMovie.insertOrUpdate(movie, watched: false, withContext: context)
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    @IBAction func seenButtonTouched(_ sender: UIButton) {
        guard let movie = movie else { return }
        AppDelegate.persistentContainer.performBackgroundTask { context in
            StoredMovie.insertOrUpdate(movie, watched: true, withContext: context)
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
