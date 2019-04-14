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

    @IBOutlet private weak var toolBar: UIToolbar!
    @IBOutlet private var deleteButton: UIBarButtonItem!

    private var state: WatchState = .undefined {
        didSet {
            updateElements(for: state)
        }
    }

    private var movie: Movie? {
        didSet {
            guard let movie = movie else { return }

            if !detailsLoaded {
                loadDetails(for: movie)
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        store.subscribe(self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        store.unsubscribe(self)
    }

    // MARK: - Actions

    @IBAction func showMoreInformation() {
        guard let url = generateMovieURL() else { return }

        let safariVC = CustomSafariViewController(url: url)
        present(safariVC, animated: true)
    }

    @IBAction func updateWatchState() {
        guard var movie = movie else { return }

        let watched = movieStateSegmentedControl.selectedSegmentIndex == 1
        movie.watched = watched

        store.dispatch(MovieAction.update(movie: movie))
    }

    @IBAction func deleteMovie() {
        guard let movie = movie else { return }

        store.dispatch(MovieAction.delete(movie: movie))
    }

    @IBAction func shareMovie() {
        guard let movie = movie else { return }

        var items = [Any]()

        items.append(movie.title)

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
            guard
                let poster = movie?.poster,
                let posterPath = movie?.posterPath
                else { return }

            let posterVC = segue.destination as? PosterViewController
            posterVC?.configure(with: poster,
                                posterPath: posterPath)
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
        guard let movie = movie else { return nil }

        let movieUrl = Constants.Backend.shareMovieUrl + "\(movie.id)"
        return URL(string: movieUrl)
    }

    fileprivate func loadDetails(for movie: Movie) {
        // Setup with the default data to show something while new data is loading
        setupUI(for: movie)

        Webservice.load(resource: movie.get) { result in
            guard case var .success(detailedMovie) = result else { return }

            detailedMovie.poster = movie.poster
            self.detailsLoaded = true
            self.movie = detailedMovie
            self.setupUI(for: detailedMovie)
        }
    }

    fileprivate func setupUI(for movie: Movie) {
        var movie = movie
        DispatchQueue.main.async {
            guard let titleLabel = self.titleLabel,
                let descriptionTextView = self.descriptionTextView,
                let releaseDateAndRuntimeLabel = self.releaseDateAndRuntimeLabel,
                let votingLabel = self.votingLabel,
                self.posterImageView != nil
                else { return }

            titleLabel.text = movie.title
            releaseDateAndRuntimeLabel.text = movie.formattedReleaseDate
                + " ∙ "
                + movie.formattedRuntime

            votingLabel.text = movie.formattedVoteAverage

            descriptionTextView.text = movie.overview

            if let posterPath = movie.posterPath {
                self.posterImageView.kf.indicatorType = .activity
                let posterUrl = Movie.posterUrl(from: posterPath, for: .small)
                self.posterImageView.kf.setImage(with: posterUrl, placeholder: UIImage.posterPlaceholder) { result in
                    if let image = try? result.get().image {
                        movie.poster = image
                    }
                }
            } else {
                self.posterImageView.image = UIImage.posterPlaceholder
            }
        }
    }

    // MARK: 3D Actions

    override var previewActionItems: [UIPreviewActionItem] {
        guard let movie = movie else { return [] }

        let watchlistAction = PreviewAction.moveToWatchlist.previewAction(for: movie)
        let seenAction = PreviewAction.moveToSeen.previewAction(for: movie)
        let deleteAction = PreviewAction.delete.previewAction(for: movie)

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

extension MovieDetailViewController: StoreSubscriber {
    func newState(state: AppState) {
        guard let selectedMovieId = state.selectedMovieId else { return }

        if let movie = state.movies.first(where: { $0.id == selectedMovieId }) {
            self.movie = movie
        } else {
            movie = Movie(id: selectedMovieId)
        }

        let state: WatchState
        if let watched = movie?.watched {
            state = watched ? .seen : .watchlist
        } else {
            state = .undefined
        }
        self.state = state
    }
}

extension MovieDetailViewController: Instantiable {
    static var storyboard: Storyboard { return .movieDetail }
    static var storyboardID: String? { return "MovieDetailViewController" }
}
