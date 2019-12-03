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

    lazy var resultSearchController: SearchController = {
        let resultSearchController = SearchController(searchResultsController: nil)
        resultSearchController.searchResultsUpdater = self
        resultSearchController.delegate = self
        return resultSearchController
    }()

    private var storedIDs = StoredMovieIDs(watchListMovieIDs: [], seenMovieIDs: []) {
        didSet {
            guard oldValue != storedIDs else { return }

            moviesWithWatchStates = updateMoviesWithWatchState(
                with: storedIDs,
                moviesFromNetworking: moviesFromNetworking
            )
        }
    }

    var moviesWithWatchStates: [Movie: WatchState] = [:] {
        didSet {
            guard oldValue != moviesWithWatchStates else { return }

            updateUI()
        }
    }

    var moviesWithoutWatchState: [Movie] {
        return moviesWithWatchStates.keys.sorted(by: SortDescriptor.sortByPopularity)
    }

    var moviesFromNetworking: Set<Movie> = [] {
        didSet {
            guard oldValue != moviesFromNetworking else { return }

            moviesWithWatchStates = updateMoviesWithWatchState(
                with: storedIDs,
                moviesFromNetworking: moviesFromNetworking
            )
        }
    }

    var currentPage: Int?
    var totalResults: Int?
    var isLoadingNextPage = false
    var searchDelayTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureElements()
        configureTableViewController()
        configureSearchController()

        loadMovies { [weak self] movies in
            DispatchQueue.main.async {
                self?.moviesFromNetworking = movies
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }

        store.subscribe(self) { subscription in
            subscription
                .select(SearchMoviesViewController.select)
                .skipRepeats()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animateSwipeActionHint()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        store.unsubscribe(self)
    }

    // MARK: - Navigation

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Actions

    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    // MARK: - Configuration

    private func configureElements() {
        title = String.addMovieTitle

        view.backgroundColor = UIColor.cineListBackground

        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.accessibilityIdentifier = "Search.NavigationBar"

        registerForPreviewing(with: self, sourceView: tableView)
    }

    private func configureTableViewController() {
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.delegate = self

        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension

        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = loadingIndicatorView

        tableView.accessibilityIdentifier = "Search.TableView"
    }

    private func configureSearchController() {
        navigationItem.searchController = resultSearchController
        navigationItem.hidesSearchBarWhenScrolling = false

        definesPresentationContext = true
    }

    // MARK: - Custom functions

    func updateMoviesWithWatchState(with storedIDs: StoredMovieIDs, moviesFromNetworking: Set<Movie>) -> [Movie: WatchState] {
        var movies: [Movie: WatchState] = [:]

        for movie in moviesFromNetworking {
            if storedIDs.watchListMovieIDs.contains(movie.id) {
                movies[movie] = .watchlist
            } else if storedIDs.seenMovieIDs.contains(movie.id) {
                movies[movie] = .seen
            } else {
                movies[movie] = .undefined
            }
        }

        return movies
    }

    func updateUI() {
        tableView.reloadData()

        if moviesWithWatchStates.isEmpty {
            tableView.tableFooterView = UIView()
        }
    }

    func scrollToTopCell(withAnimation: Bool) {
        guard !moviesWithWatchStates.isEmpty else { return }

        tableView.scrollToRow(
            at: IndexPath(row: 0, section: 0),
            at: .top,
            animated: withAnimation
        )
    }
}

extension SearchMoviesViewController: StoreSubscriber {
    struct State: Equatable {
        let storedIDs: StoredMovieIDs
    }

    private static func select(state: AppState) -> State {
        return .init(storedIDs: state.storedIDs)
    }

    func newState(state: State) {
        storedIDs = state.storedIDs
    }
}

extension SearchMoviesViewController: Instantiable {
    static var storyboard: Storyboard { return .search }
    static var storyboardID: String? { return "SearchMoviesViewController" }
}
