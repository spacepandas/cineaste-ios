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

            movies = updateMoviesWithWatchState(
                with: storedIDs,
                moviesFromNetworking: moviesFromNetworking
            )
        }
    }

    let dataSource = SearchMovieDataSource()

    var movies: [Movie] = [] {
        didSet {
            guard oldValue != movies else { return }

            dataSource.movies = movies
            updateUI()
        }
    }

    var moviesFromNetworking: Set<Movie> = [] {
        didSet {
            guard oldValue != moviesFromNetworking else { return }

            movies = updateMoviesWithWatchState(
                with: storedIDs,
                moviesFromNetworking: moviesFromNetworking
            )
        }
    }

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
        .lightContent
    }

    // MARK: - Actions

    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    // MARK: - Configuration

    private func configureElements() {
        title = String.discoverMovieTitle

        view.backgroundColor = UIColor.cineListBackground

        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.accessibilityIdentifier = "Search.NavigationBar"

        registerForPreviewing(with: self, sourceView: tableView)
    }

    private func configureTableViewController() {
        tableView.dataSource = dataSource
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

        resultSearchController.searchBar.searchTextField.delegate = self
    }

    // MARK: - Custom functions

    func updateMoviesWithWatchState(with storedIDs: StoredMovieIDs, moviesFromNetworking: Set<Movie>) -> [Movie] {

        moviesFromNetworking.map { movie in
            var movie = movie
            if storedIDs.watchListMovieIDs.contains(movie.id) {
                movie.watched = false
            } else if storedIDs.seenMovieIDs.contains(movie.id) {
                movie.watched = true
            } else {
                movie.watched = nil
            }
            return movie
        }
        .sorted(by: SortDescriptor.sortByPopularity)
    }

    func updateUI() {
        tableView.reloadData()

        if movies.isEmpty {
            tableView.tableFooterView = UIView()
        }
    }

    func scrollToTopCell(withAnimation: Bool) {
        guard !movies.isEmpty else { return }

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
        .init(storedIDs: state.storedIDs)
    }

    func newState(state: State) {
        storedIDs = state.storedIDs
    }
}

extension SearchMoviesViewController: Instantiable {
    static var storyboard: Storyboard { .search }
    static var storyboardID: String? { "SearchMoviesViewController" }
}
