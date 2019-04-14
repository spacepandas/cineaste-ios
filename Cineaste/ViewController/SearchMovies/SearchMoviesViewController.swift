//
//  SearchMoviesViewController.swift
//  Cineaste
//
//  Created by Christian Braun on 02.11.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit
import ReSwift

class SearchMoviesViewController: UIViewController {
    @IBOutlet weak var loadingIndicatorView: UIView!
    @IBOutlet weak var tableView: UITableView!

    var movies: [Movie] {
        return watchStates.keys
            .sorted { $0.popularity > $1.popularity }
    }

    var watchStates: [Movie: WatchState] = [:]

    private var storedIDs: (watchListMovieIDs: [Int64], seenMovieIDs: [Int64]) = ([], []) {
        didSet {
            updateMovies()
        }
    }

    var moviesFromNetworking: Set<Movie> = [] {
        didSet {
            updateMovies()
        }
    }

    func updateMovies() {
        for movie in moviesFromNetworking {
            if storedIDs.watchListMovieIDs.contains(movie.id) {
                watchStates[movie] = .watchlist
            } else if storedIDs.seenMovieIDs.contains(movie.id) {
                watchStates[movie] = .seen
            } else {
                watchStates[movie] = .undefined
            }
        }
        DispatchQueue.main.async {
            self.updateUI()
        }
    }

    var selectedMovie: Movie?

    var currentPage: Int?
    var totalResults: Int?

    var isLoadingNextPage = false

    var searchDelayTimer: Timer?

    lazy var resultSearchController: SearchController = {
        let resultSearchController = SearchController(searchResultsController: nil)
        resultSearchController.searchResultsUpdater = self
        resultSearchController.delegate = self
        return resultSearchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = String.addMovieTitle

        view.backgroundColor = UIColor.basicBackground

        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }

        loadMovies { [weak self] movies in
            self?.moviesFromNetworking = movies
        }

        configureTableViewController()
        configureSearchController()
        registerForPreviewing(with: self, sourceView: tableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if #available(iOS 11.0, *) {
            return
        } else {
            resultSearchController.searchBar.sizeToFit()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }

        store.subscribe(self) { subscription in
            subscription.select { state in
                //swiftlint:disable:next force_unwrapping
                (state.movies.filter { !$0.watched! }.map { $0.id },
                 //swiftlint:disable:next force_unwrapping
                 state.movies.filter { $0.watched! }.map { $0.id })
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let cell = tableView.visibleCells.first as? SearchMoviesCell {
            cell.animateSwipeHint()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        store.unsubscribe(self)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch Segue(initWith: segue) {
        case .showMovieDetail?:
            guard let selectedMovie = selectedMovie else { return }

            store.dispatch(MovieAction.select(movie: selectedMovie))
        default:
            return
        }
    }

    // MARK: - Actions

    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    // MARK: - Configuration

    func configureTableViewController() {
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.delegate = self

        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension

        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = loadingIndicatorView
    }

    func configureSearchController() {
        if #available(iOS 11.0, *) {
            navigationItem.searchController = resultSearchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = resultSearchController.searchBar
        }

        definesPresentationContext = true
    }

    // MARK: - Custom functions

    func updateUI() {
        tableView.reloadData()

        if watchStates.isEmpty {
            tableView.tableFooterView = UIView()
        }
    }

    func scrollToTopCell(withAnimation: Bool) {
        guard !watchStates.isEmpty else { return }

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath,
                                       at: .top,
                                       animated: withAnimation)
        }
    }

    func shouldMark(movie: Movie, state: WatchState) {
        loadDetails(for: movie) { detailedMovie in
            guard var detailedMovie = detailedMovie else { return }

            switch state {
            case .undefined:
                break
            case .seen:
                detailedMovie.watched = true
            case .watchlist:
                detailedMovie.watched = false
            }
            store.dispatch(MovieAction.update(movie: detailedMovie))
        }
    }
}

extension SearchMoviesViewController: StoreSubscriber {
    func newState(state: (watchListMovieIDs: [Int64], seenMovieIDs: [Int64])) {
        storedIDs = state
    }
}

extension SearchMoviesViewController: Instantiable {
    static var storyboard: Storyboard { return .search }
    static var storyboardID: String? { return "SearchMoviesViewController" }
}
