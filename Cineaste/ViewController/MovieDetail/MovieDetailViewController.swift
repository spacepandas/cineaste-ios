//
//  MovieDetailViewController.swift
//  Cineaste
//
//  Created by Christian Braun on 04.11.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit
import CoreData
import SafariServices

//swiftlint:disable type_body_length
class MovieDetailViewController: UIViewController {
    @IBOutlet weak fileprivate var posterImageView: UIImageView!
    @IBOutlet weak fileprivate var posterHeight: NSLayoutConstraint!
    @IBOutlet weak fileprivate var titleLabel: TitleLabel!

    @IBOutlet var descriptionLabels: [DescriptionLabel]! {
        didSet {
            for label in descriptionLabels {
                label.textColor = UIColor.basicBackground
            }
        }
    }
    @IBOutlet weak fileprivate var detailScrollView: UIScrollView!
    @IBOutlet weak fileprivate var releaseDateLabel: DescriptionLabel!
    @IBOutlet weak fileprivate var runtimeLabel: DescriptionLabel!
    @IBOutlet weak fileprivate var votingLabel: DescriptionLabel! {
        didSet {
            votingLabel.textColor = UIColor.black
        }
    }

    @IBOutlet var moreInformationButton: ActionButton!
    @IBOutlet var seenButton: ActionButton!
    @IBOutlet var mustSeeButton: ActionButton!
    @IBOutlet var deleteButton: ActionButton!

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

            let changedMovie = oldValue?.id != movie.id
            if changedMovie {
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

    var moviePoster: UIImage? {
        didSet {
            DispatchQueue.main.async {
                guard let poster = self.moviePoster else { return }
                self.posterImageView.image = poster
                let aspectRatio = poster.size.height / poster.size.width
                self.posterHeight.constant = aspectRatio * UIScreen.main.bounds.width
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }

        updateDetail(for: type)
        setupLocalization()

        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .action,
                            target: self,
                            action: #selector(shareMovie))

        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(showPoster))
        posterImageView.isUserInteractionEnabled = true
        posterImageView.addGestureRecognizer(gestureRecognizer)

        moreInformationButton.setTitle(String.moreInformation, for: .normal)
    }

    // MARK: - Actions

    @IBAction func mustSeeButtonTouched(_ sender: UIButton) {
        saveMovie(asWatched: false)
    }

    @IBAction func seenButtonTouched(_ sender: UIButton) {
        saveMovie(asWatched: true)
    }

    @IBAction func deleteButtonTouched(_ sender: UIButton) {
        deleteMovie()
    }

    @IBAction func showMoreInformation(_ sender: UIButton) {
        guard let url = generateMovieURL() else { return }

        let safariVC = CustomSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch Segue(initWith: segue) {
        case .showPosterFromMovieDetail?:
            let posterVC = segue.destination as? PosterViewController
            if let storedMovie = storedMovie,
                let poster = storedMovie.poster {
                posterVC?.image = UIImage(data: poster)
                posterVC?.posterPath = storedMovie.posterPath
            } else if let movie = movie {
                posterVC?.image = movie.poster
                posterVC?.posterPath = movie.posterPath
            }
        default:
            break
        }
    }

    // MARK: - Gesture Recognizer

    @objc
    func showPoster() {
        guard posterImageView.image != UIImage.posterPlaceholder else { return }
        perform(segue: .showPosterFromMovieDetail, sender: nil)
    }

    @objc
    func shareMovie(_ sender: UIBarButtonItem) {
        var title: String?

        if let movie = storedMovie {
            title = movie.title
        } else if let movie = movie {
            title = movie.title
        }

        var items = [Any]()

        if let title = title {
            items.append(title)
        }

        if let url = generateMovieURL() {
            items.append(url)
        }

        let activityController =
            UIActivityViewController(activityItems: items,
                                     applicationActivities: nil)

        present(activityController, animated: true, completion: nil)
    }

    // MARK: - Private

    fileprivate func setupLocalization() {
        seenButton.setTitle(String.seenAction, for: .normal)
        mustSeeButton.setTitle(String.watchlistAction, for: .normal)
        deleteButton.setTitle(String.deleteActionLong, for: .normal)
    }

    fileprivate func generateMovieURL() -> URL? {
        var movieUrl = Config.Backend.shareMovieUrl

        if let movie = storedMovie {
            movieUrl += "\(movie.id)"
        } else if let movie = movie {
            movieUrl += "\(movie.id)"
        } else {
            preconditionFailure("Either movie or storedMovie must be set to generate share movie url")
        }

        return URL(string: movieUrl)
    }

    fileprivate func saveMovie(asWatched watched: Bool) {
        guard let storageManager = storageManager else { return }

        if let movie = movie {
            storageManager.insertMovieItem(with: movie,
                                           watched: watched) { result in
                switch result {
                case .error:
                    self.showAlert(withMessage: Alert.insertMovieError)
                case .success:
                    DispatchQueue.main.async {
                        self.dismiss(animated: true)
                    }
                }
            }
        } else if let storedMovie = storedMovie {
            storageManager.updateMovieItem(with: storedMovie,
                                           watched: watched) { result in
                switch result {
                case .error:
                    self.showAlert(withMessage: Alert.updateMovieError)
                case .success:
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else {
            preconditionFailure("Either movie or storedMovie must be set to save it")
        }
    }

    fileprivate func deleteMovie() {
        guard let storageManager = storageManager,
            let storedMovie = storedMovie else { return }

        storageManager.remove(storedMovie) { result in
            switch result {
            case .error:
                self.showAlert(withMessage: Alert.deleteMovieError)
            case .success:
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
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
        case .watchlist:
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
        setupUI(for: movie)

        Webservice.load(resource: movie.get) { result in
            guard case let .success(detailedMovie) = result else { return }

            detailedMovie.poster = movie.poster
            self.movie = detailedMovie
            self.setupUI(for: detailedMovie)
        }
    }

    fileprivate func setupUI(for networkMovie: Movie) {
        moviePoster = networkMovie.poster ?? UIImage.posterPlaceholder

        DispatchQueue.main.async {
            guard let titleLabel = self.titleLabel,
                let descriptionTextView = self.descriptionTextView,
                let runtimeLabel = self.runtimeLabel,
                let votingLabel = self.votingLabel,
                let releaseDateLabel = self.releaseDateLabel else { return }

            titleLabel.text = networkMovie.title
            descriptionTextView.text = networkMovie.overview
            runtimeLabel.text = networkMovie.formattedRuntime
            votingLabel.text = networkMovie.formattedVoteAverage
            releaseDateLabel.text = networkMovie.formattedReleaseDate
        }
    }

    fileprivate func setupUI(for localMovie: StoredMovie) {
        moviePoster = localMovie.poster.map(UIImage.init) ?? UIImage.posterPlaceholder

        DispatchQueue.main.async {
            guard let titleLabel = self.titleLabel,
                let descriptionTextView = self.descriptionTextView,
                let runtimeLabel = self.runtimeLabel,
                let votingLabel = self.votingLabel,
                let releaseDateLabel = self.releaseDateLabel else { return }

            titleLabel.text = localMovie.title
            descriptionTextView.text = localMovie.overview
            runtimeLabel.text = localMovie.formattedRuntime
            votingLabel.text = localMovie.formattedVoteAverage
            releaseDateLabel.text = localMovie.formattedReleaseDate
        }
    }

    // MARK: 3D Actions

    override var previewActionItems: [UIPreviewActionItem] {
        let watchlistAction = UIPreviewAction(title: String.watchlistAction,
                                              style: .default) { _, _ -> Void in
            self.saveMovie(asWatched: false)
        }

        let seenAction = UIPreviewAction(title: String.seenAction,
                                         style: .default) { _, _ -> Void in
            self.saveMovie(asWatched: true)
        }

        let deleteAction = UIPreviewAction(title: String.deleteActionLong,
                                           style: .destructive) { _, _ -> Void in
            self.deleteMovie()
        }

        switch type {
        case .seen:
            return [watchlistAction, deleteAction]
        case .watchlist:
            return [seenAction, deleteAction]
        case .search:
            return [watchlistAction, seenAction]
        }

    }
}

extension MovieDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let outerMaxOffset = scrollView.contentSize.height - scrollView.frame.height
        let percentage = scrollView.contentOffset.y / outerMaxOffset
        let detailRatio = detailScrollView.frame.height / detailScrollView.contentSize.height

        let offset = percentage * outerMaxOffset * detailRatio
        if offset < 0 {
            detailScrollView.contentOffset.y = -scrollView.contentOffset.y
        } else {
            detailScrollView.contentOffset.y = offset
        }
    }
}

extension MovieDetailViewController: Instantiable {
    static var storyboard: Storyboard { return .movieDetail }
    static var storyboardID: String? { return "MovieDetailViewController" }
}
//swiftlint:enable type_body_length
