//
//  MovieDetailViewController.swift
//  Cineaste
//
//  Created by Christian Braun on 04.11.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit
import SafariServices

//swiftlint:disable type_body_length
class MovieDetailViewController: UIViewController {
    enum MovieType {
        case stored(StoredMovie)
        case network(Movie)
    }

    @IBOutlet private weak var detailScrollView: UIScrollView!
    @IBOutlet private weak var contentStackView: UIStackView!
    @IBOutlet private weak var moreInformationStackView: UIStackView!

    @IBOutlet private weak var posterImageView: UIImageView! {
        didSet {
            guard let poster = posterImageView.image
                else { return }

            DispatchQueue.main.async {
                let aspectRatio = poster.size.height / poster.size.width
                self.posterHeight.constant = aspectRatio * UIScreen.main.bounds.width
            }
        }
    }
    @IBOutlet private weak var posterHeight: NSLayoutConstraint!

    @IBOutlet private weak var votingLabel: UILabel!

    @IBOutlet private weak var titleLabel: TitleLabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var releaseDateAndRuntimeLabel: UILabel!

    @IBOutlet private weak var moreInformationButton: ActionButton!
    @IBOutlet private weak var buttonInfoLabel: UILabel!

    @IBOutlet private weak var movieStateSegmentedControl: UISegmentedControl!

    @IBOutlet private weak var descriptionTextView: DescriptionTextView!

    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet private var deleteButton: UIBarButtonItem!

    private var storageManager: MovieStorageManager?

    private var state: WatchState = .undefined {
        didSet {
            updateElements(for: state)
        }
    }

    private var movie: MovieType? {
        didSet {
            guard let movie = movie else { return }

            switch movie {
            case .stored(let storedMovie):
                setupUI(for: storedMovie)
            case .network(let networkMovie):
                if !detailsLoaded {
                    loadDetails(for: networkMovie)
                }
            }
        }
    }
    private var detailsLoaded = false

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }

        setupLocalization()
        configureElements()
    }

    func configure(with selectedMovie: MovieType,
                   state: WatchState,
                   storageManager: MovieStorageManager) {
        movie = selectedMovie
        self.state = state
        self.storageManager = storageManager
    }

    // MARK: - Actions

    @IBAction func showMoreInformation() {
        guard let url = generateMovieURL() else { return }

        let safariVC = CustomSafariViewController(url: url)
        present(safariVC, animated: true)
    }

    @IBAction func updateWatchState() {
        if movieStateSegmentedControl.selectedSegmentIndex == 0 {
            saveMovie(asWatched: false)
        } else if movieStateSegmentedControl.selectedSegmentIndex == 1 {
            saveMovie(asWatched: true)
        }
    }

    @IBAction func deleteMovie() {
        guard let storageManager = storageManager,
            let movie = movie
            else { return }

        switch movie {
        case .network(let movie):
            storageManager.save(movie, state: .undefined) { result in
                switch result {
                case .failure:
                    self.showAlert(withMessage: Alert.insertMovieError)
                case .success:
                    DispatchQueue.main.async {
                        self.updateElements(for: .undefined)
                    }
                }
            }
        case .stored(let movie):
            storageManager.remove(with: movie.objectID) { result in
                switch result {
                case .failure:
                    self.showAlert(withMessage: Alert.deleteMovieError)
                case .success:
                    DispatchQueue.main.async {
                        self.updateElements(for: .undefined)
                    }
                }
            }
        }
    }

    @IBAction func shareMovie() {
        var title: String?
        guard let movie = movie else { return }

        switch movie {
        case .network(let movie):
            title = movie.title
        case .stored(let movie):
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

        present(activityController, animated: true)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch Segue(initWith: segue) {
        case .showPosterFromMovieDetail?:
            guard let movie = movie else { return }

            let posterVC = segue.destination as? PosterViewController
            switch movie {
            case .network(let movie):
                guard let poster = movie.poster,
                    let posterPath = movie.posterPath
                    else { return }

                posterVC?.configure(with: poster,
                                    posterPath: posterPath)
            case .stored(let movie):
                guard let poster = movie.poster,
                    let image = UIImage(data: poster),
                    let posterPath = movie.posterPath
                    else { return }

                posterVC?.configure(with: image,
                                    posterPath: posterPath)
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

    // MARK: - Private

    private func configureElements() {
        if #available(iOS 11.0, *) {
            contentStackView.setCustomSpacing(30, after: moreInformationStackView)
        }

        categoryLabel.isHidden = true
        votingLabel.textColor = UIColor.black
        buttonInfoLabel.textColor = UIColor.basicBackground
        movieStateSegmentedControl.tintColor = UIColor.primaryOrange

        posterImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(showPoster))
        posterImageView.addGestureRecognizer(gestureRecognizer)

        updateElements(for: state)
    }

    private func setupLocalization() {
        moreInformationButton.setTitle(String.moreInformation, for: .normal)
        buttonInfoLabel.text = String.onTMDB

        movieStateSegmentedControl.setTitle(.watchStateWatchlist, forSegmentAt: 0)
        movieStateSegmentedControl.setTitle(.watchStateSeen, forSegmentAt: 1)
    }

    private func updateElements(for state: WatchState) {
        guard let control = movieStateSegmentedControl,
            let toolBar = toolBar
            else { return }

        func addDeleteButtonToToolbar() {
            if !(toolBar.items?.contains(deleteButton) ?? false) {
                toolBar.items?.insert(deleteButton, at: 0)
                toolBar.setItems(toolBar.items, animated: true)
            }
        }

        switch state {
        case .undefined:
            control.selectedSegmentIndex = UISegmentedControl.noSegment

            var movieToolbarItems = toolBar.items
            movieToolbarItems?.removeAll { $0 == deleteButton }
            toolBar.setItems(movieToolbarItems, animated: true)
        case .seen:
            control.selectedSegmentIndex = 1

            addDeleteButtonToToolbar()
        case .watchlist:
            control.selectedSegmentIndex = 0

            addDeleteButtonToToolbar()
        }
    }

    private func generateMovieURL() -> URL? {
        var movieUrl = Constants.Backend.shareMovieUrl

        guard let movie = movie else { return nil }

        switch movie {
        case .network(let movie):
            movieUrl += "\(movie.id)"
        case .stored(let movie):
            movieUrl += "\(movie.id)"
        }

        return URL(string: movieUrl)
    }

    private func saveMovie(asWatched watched: Bool) {
        guard let storageManager = storageManager,
            let movie = movie
            else { return }

        switch movie {
        case .network(let movie):
            let newState: WatchState = watched ? .seen : .watchlist
            storageManager.save(movie, state: newState) { result in
                switch result {
                case .failure:
                    self.showAlert(withMessage: Alert.insertMovieError)
                case .success:
                    DispatchQueue.main.async {
                        self.updateElements(for: newState)
                    }
                }
            }
        case .stored(let movie):
            let newState: WatchState = watched ? .seen : .watchlist
            storageManager.updateMovieItem(with: movie.objectID, watched: watched) { result in
                switch result {
                case .failure:
                    self.showAlert(withMessage: Alert.updateMovieError)
                case .success:
                    DispatchQueue.main.async {
                        self.updateElements(for: newState)
                    }
                }
            }
        }
    }

    fileprivate func loadDetails(for movie: Movie) {
        // Setup with the default data to show something while new data is loading
        setupUI(for: movie)

        Webservice.load(resource: movie.get) { result in
            guard case let .success(detailedMovie) = result else { return }

            detailedMovie.poster = movie.poster
            self.detailsLoaded = true
            self.movie = .network(detailedMovie)
            self.setupUI(for: detailedMovie)
        }
    }

    fileprivate func setupUI(for networkMovie: Movie) {
        DispatchQueue.main.async {
            guard let titleLabel = self.titleLabel,
                let descriptionTextView = self.descriptionTextView,
                let releaseDateAndRuntimeLabel = self.releaseDateAndRuntimeLabel,
                let votingLabel = self.votingLabel,
                self.posterImageView != nil
                else { return }

            titleLabel.text = networkMovie.title
            releaseDateAndRuntimeLabel.text = networkMovie.formattedReleaseDate
                + " ∙ "
                + networkMovie.formattedRuntime

            votingLabel.text = networkMovie.formattedVoteAverage

            descriptionTextView.text = networkMovie.overview

            if let posterPath = networkMovie.posterPath {
                self.posterImageView.kf.indicatorType = .activity
                let posterUrl = Movie.posterUrl(from: posterPath, for: .small)
                self.posterImageView.kf.setImage(with: posterUrl, placeholder: UIImage.posterPlaceholder) { result in
                    if let image = try? result.get().image {
                        networkMovie.poster = image
                    }
                }
            } else {
                self.posterImageView.image = UIImage.posterPlaceholder
            }
        }
    }

    fileprivate func setupUI(for localMovie: StoredMovie) {
        DispatchQueue.main.async {
            guard let titleLabel = self.titleLabel,
                let descriptionTextView = self.descriptionTextView,
                let releaseDateAndRuntimeLabel = self.releaseDateAndRuntimeLabel,
                let votingLabel = self.votingLabel,
                let posterImageView = self.posterImageView
                else { return }

            titleLabel.text = localMovie.title
            descriptionTextView.text = localMovie.overview
            releaseDateAndRuntimeLabel.text = localMovie.formattedReleaseDate
                + " ∙ "
                + localMovie.formattedRuntime

            votingLabel.text = localMovie.formattedVoteAverage
            posterImageView.image = localMovie.poster.map(UIImage.init)
                ?? UIImage.posterPlaceholder
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

        guard case .stored? = movie else {
            // no preview actions in search
            return []
        }

        let actions: [UIPreviewActionItem]
        switch state {
        case .seen:
            actions = [watchlistAction, deleteAction]
        case .watchlist:
            actions = [seenAction, deleteAction]
        case .undefined:
            actions = []
        }
        return actions
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
