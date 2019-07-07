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
            .sorted(by: SortDescriptor.sortByPopularity)
    }

    var watchStates: [Movie: WatchState] = [:]

    private var storedIDs = StoredMovieIDs(watchListMovieIDs: [], seenMovieIDs: []) {
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
        watchStates = [:]
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

        navigationItem.largeTitleDisplayMode = .never

        loadMovies { [weak self] movies in
            self?.moviesFromNetworking = movies
        }

        configureTableViewController()
        configureSearchController()
        registerForPreviewing(with: self, sourceView: tableView)
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

            store.dispatch(SelectionAction.select(movie: selectedMovie))
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
        navigationItem.searchController = resultSearchController
        navigationItem.hidesSearchBarWhenScrolling = false

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
