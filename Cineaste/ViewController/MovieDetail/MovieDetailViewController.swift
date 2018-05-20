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
            self.mustSeeButton.setTitle(Strings.wantToSeeButton, for: .normal)
        }
    }
    @IBOutlet var deleteButton: ActionButton! {
        didSet {
            self.deleteButton.setTitle(Strings.deleteButton, for: .normal)
        }
    }

    @IBOutlet weak fileprivate var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.isEditable = false
        }
    }

    var type: MovieDetailType = .search {
        didSet {
            updateDetail(for: type)
        }
    }

    var storageManager: MovieStorage?

    var movie: Movie? {
        didSet {
            guard let movie = movie else { return }

            if oldValue?.id != movie.id {
                loadDetails(for: movie)
            }
        }
    }

    var storedMovie: StoredMovie? {
        didSet {
            if let movie = storedMovie {
                setupUI(for: movie)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateDetail(for: type)

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(shareMovie))
    }

    // MARK: - Actions

    @IBAction func mustSeeButtonTouched(_ sender: UIButton) {
        saveMovie(withWatched: false)
    }

    @IBAction func seenButtonTouched(_ sender: UIButton) {
        saveMovie(withWatched: true)
    }

    @IBAction func deleteButtonTouched(_ sender: UIButton) {
        deleteMovie()
    }

    @objc
    func shareMovie(_ sender: UIBarButtonItem) {
        var title: String?
        var movieUrl = Config.Backend.shareMovieUrl

        if let movie = storedMovie {
            title = movie.title
            movieUrl += "\(movie.id)"
        } else if let movie = movie {
            title = movie.title
            movieUrl += "\(movie.id)"
        }

        var items = [Any]()

        if let title = title {
            items.append(title)
        }

        if let url = URL(string: movieUrl) {
            items.append(url)
        }

        let activityController = UIActivityViewController(activityItems: items,
                                                          applicationActivities: nil)

        present(activityController, animated: true, completion: nil)
    }

    // MARK: - Private

    fileprivate func saveMovie(withWatched watched: Bool) {
        guard let storageManager = storageManager else { return }

        if let movie = movie {
            storageManager.insertMovieItem(with: movie, watched: watched) { result in
                switch result {
                case .error:
                    DispatchQueue.main.async {
                        self.showAlert(withMessage: Alert.insertMovieError)
                    }
                case .success:
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        } else if let storedMovie = storedMovie {
            storageManager.updateMovieItem(with: storedMovie, watched: watched) { result in
                switch result {
                case .error:
                    DispatchQueue.main.async {
                        self.showAlert(withMessage: Alert.updateMovieError)
                    }
                case .success:
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }

    fileprivate func deleteMovie() {
        guard let storageManager = storageManager else { return }

        if let storedMovie = storedMovie {
            storageManager.remove(storedMovie, handler: { result in
                guard case .success = result else {
                    self.showAlert(withMessage: Alert.deleteMovieError)
                    return
                }

                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }

    private func updateDetail(for type: MovieDetailType) {
        guard let mustSeeButton = mustSeeButton,
            let seenButton = seenButton,
            let deleteButton = deleteButton else {
                return
        }

        switch type {
        case .seen:
            mustSeeButton.isHidden = false
            seenButton.isHidden = true
            deleteButton.isHidden = false
        case .wantToSee:
            mustSeeButton.isHidden = true
            seenButton.isHidden = false
            deleteButton.isHidden = false
        case .search:
            mustSeeButton.isHidden = false
            seenButton.isHidden = false
            deleteButton.isHidden = true
        }
    }

    fileprivate func loadDetails(for movie: Movie) {
        // Setup with the default data to show something while new data is loading
        self.setupUI(for: movie)

        Webservice.load(resource: movie.get) { result in
            guard case let .success(detailedMovie) = result else { return }

            detailedMovie.poster = movie.poster
            self.movie = detailedMovie
            self.setupUI(for: detailedMovie)
        }
    }

    fileprivate func setupUI(for networkMovie: Movie) {
        DispatchQueue.main.async {
            if let moviePoster = networkMovie.poster {
                self.posterImageView.image = moviePoster
            }
            self.titleLabel.text = networkMovie.title
            self.descriptionTextView.text = networkMovie.overview
            self.runtimeLabel.text = networkMovie.formattedRuntime
            self.votingLabel.text = networkMovie.formattedVoteAverage
            self.releaseDateLabel.text = networkMovie.formattedReleaseDate
        }
    }

    fileprivate func setupUI(for localMovie: StoredMovie) {
        DispatchQueue.main.async {
            if let moviePoster = localMovie.poster {
                self.posterImageView.image = UIImage(data: moviePoster)
            }
            self.titleLabel.text = localMovie.title
            self.descriptionTextView.text = localMovie.overview
            self.runtimeLabel.text = localMovie.formattedRuntime
            self.votingLabel.text = localMovie.formattedVoteAverage
            self.releaseDateLabel.text = localMovie.formattedReleaseDate
        }
    }

    // MARK: 3D Actions

    override var previewActionItems: [UIPreviewActionItem] {
        let wantToSeeAction = UIPreviewAction(title: Strings.wantToSeeButton, style: .default) { _, _ -> Void in
            self.saveMovie(withWatched: false)
        }

        let seenAction = UIPreviewAction(title: Strings.seenButton, style: .default) { _, _ -> Void in
            self.saveMovie(withWatched: true)
        }

        let deleteAction = UIPreviewAction(title: Strings.deleteButton, style: .destructive) { _, _ -> Void in
            self.deleteMovie()
        }

        switch type {
        case .seen:
            return [wantToSeeAction, deleteAction]
        case .wantToSee:
            return [seenAction, deleteAction]
        case .search:
            return [wantToSeeAction, seenAction]
        }

    }
}

extension MovieDetailViewController: Instantiable {
    static var storyboard: Storyboard { return .movieDetail }
    static var storyboardID: String? { return "MovieDetailViewController" }
}
