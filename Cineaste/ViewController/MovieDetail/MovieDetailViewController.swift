//
//  MovieDetailViewController.swift
//  Cineaste
//
//  Created by Christian Braun on 04.11.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit
import ReSwift
import SafariServices

class MovieDetailViewController: UIViewController {
    @IBOutlet private weak var detailScrollView: UIScrollView!
    @IBOutlet private weak var contentStackView: UIStackView!
    @IBOutlet private weak var moreInformationStackView: UIStackView!

    @IBOutlet private weak var posterImageView: UIImageView! {
        didSet {
            DispatchQueue.main.async {
                self.updatePosterHeight()
            }
        }
    }

    @IBOutlet private weak var posterHeight: NSLayoutConstraint!

    @IBOutlet private weak var triangleImageView: UIImageView!
    @IBOutlet private weak var votingLabel: UILabel!
    @IBOutlet private weak var background: UIView!

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    @IBOutlet private weak var releaseDateAndRuntimeLabel: UILabel!

    @IBOutlet private weak var moreInformationButton: UIButton!
    @IBOutlet private weak var buttonInfoLabel: UILabel!

    @IBOutlet private weak var movieStateSegmentedControl: UISegmentedControl!

    @IBOutlet private weak var descriptionTextView: DescriptionTextView!

    @IBOutlet private weak var toolBar: UIToolbar!
    @IBOutlet private var deleteButton: UIBarButtonItem!

    private var watchState: WatchState = .undefined {
        didSet {
            guard oldValue != watchState else { return }

            updateElements(for: watchState)
        }
    }

    private var movie: Movie? {
        didSet {
            guard let movie = movie,
                oldValue != movie
                else { return }

            updateUI(for: movie)

            if !detailsLoaded {
                loadDetails(for: movie)
            }
        }
    }
    private var detailsLoaded = false

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never

        configureElements()
        setupLocalization()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        store.subscribe(self) { subscription in
            subscription
                .select(MovieDetailViewController.select)
                .skipRepeats()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        store.unsubscribe(self)
    }

    // MARK: - Actions

    @IBAction func showMoreInformation() {
        guard let movie = movie,
            let url = Constants.Backend.shareUrl(for: movie)
            else { return }

        let safariVC = CustomSafariViewController(url: url)
        present(safariVC, animated: true)
    }

    @IBAction func updateWatchState() {
        guard let movie = movie else { return }

        let watched = movieStateSegmentedControl.selectedSegmentIndex == 1
        store.dispatch(markMovie(movie, watched: watched))
    }

    @IBAction func deleteMovieFromList() {
        guard let movie = movie else { return }

        store.dispatch(deleteMovie(movie))
    }

    @IBAction func shareMovie() {
        guard let movie = movie else { return }

        share(movie: movie)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch Segue(initWith: segue) {
        case .showPosterFromMovieDetail?:
            guard let posterPath = movie?.posterPath else { return }

            let posterVC = segue.destination as? PosterViewController
            posterVC?.configure(with: posterPath)
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
        view.backgroundColor = .cineContentBackground

        contentStackView.setCustomSpacing(30, after: moreInformationStackView)
        triangleImageView.tintColor = .cineContentBackground
        background.backgroundColor = .cineContentBackground
        votingLabel.textColor = UIColor.black
        buttonInfoLabel.textColor = UIColor.cineDescription
        posterImageView.accessibilityIgnoresInvertColors = true
        posterImageView.isUserInteractionEnabled = true
        posterImageView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(showPoster)
            )
        )

        updateElements(for: watchState)
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

    private func loadDetails(for movie: Movie) {
        Webservice.load(resource: movie.get) { result in
            guard case let .success(detailedMovie) = result else { return }

            DispatchQueue.main.async {
                self.detailsLoaded = true
                self.movie = detailedMovie
            }
        }
    }

    private func updateUI(for movie: Movie) {
        guard let titleLabel = titleLabel,
            let descriptionTextView = descriptionTextView,
            let releaseDateAndRuntimeLabel = releaseDateAndRuntimeLabel,
            let votingLabel = votingLabel,
            let genreLabel = genreLabel,
            let posterImageView = posterImageView
            else { return }

        titleLabel.text = movie.title
        releaseDateAndRuntimeLabel.text = movie.formattedReleaseDate
            + " ∙ "
            + movie.formattedRuntime

        if !movie.formattedGenres.isEmpty {
            genreLabel.isHidden = false
            genreLabel.text = movie.formattedGenres
        } else {
            genreLabel.isHidden = true
        }

        votingLabel.text = movie.formattedVoteAverage
        descriptionTextView.text = movie.overview
        posterImageView.loadingImage(from: movie.posterPath, in: .original)
    }

    private func updatePosterHeight() {
        guard let poster = posterImageView.image else { return }

        let aspectRatio = poster.size.height / poster.size.width
        posterHeight.constant = aspectRatio * UIScreen.main.bounds.width
    }

    // MARK: 3D Actions

    override var previewActionItems: [UIPreviewActionItem] {
        guard let movie = movie else { return [] }

        let watchlistAction = PreviewAction.moveToWatchlist.previewAction(for: movie)
        let seenAction = PreviewAction.moveToSeen.previewAction(for: movie)
        let deleteAction = PreviewAction.delete.previewAction(for: movie)

        let actions: [UIPreviewActionItem]
        switch watchState {
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
            // disable parallax effect when reduce motion is enabled
            guard !UIAccessibility.isReduceMotionEnabled else { return }

            detailScrollView.contentOffset.y = offset
        }
    }
}

extension MovieDetailViewController: StoreSubscriber {
    struct State: Equatable {
        let movieId: Int64
        let movie: Movie?
    }

    private static func select(state: AppState) -> State {
        guard let selectedMovie = state.selectedMovieState.movie else {
            fatalError("This ViewController should always have a movie")
        }

        let movie = state.movies.first { $0.id == selectedMovie.id }
            ?? selectedMovie

        return .init(
            movieId: selectedMovie.id,
            movie: movie
        )
    }

    func newState(state: State) {
        let selectedMovie: Movie
        if let movie = state.movie {
            selectedMovie = movie
        } else if var oldMovie = movie, oldMovie.id == state.movieId {
            oldMovie.watched = nil
            oldMovie.watchedDate = nil
            selectedMovie = oldMovie
        } else {
            selectedMovie = Movie(id: state.movieId)
            detailsLoaded = false
        }

        movie = selectedMovie
        watchState = selectedMovie.currentWatchState
    }
}

extension MovieDetailViewController: Instantiable {
    static var storyboard: Storyboard { return .movieDetail }
    static var storyboardID: String? { return "MovieDetailViewController" }
}
