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

    let dataSource = SearchMovieDataSource()

    var movies: [Movie] = [] {
        didSet {
            guard oldValue != movies else { return }

            dataSource.movies = movies
            tableView.reloadData()
        }
    }

    var isLoadingNextPage = false
    var searchDelayTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureElements()
        configureTableViewController()
        configureSearchController()

        store.dispatch(fetchSearchResults)
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
    }
}

extension SearchMoviesViewController: StoreSubscriber {
    struct State: Equatable {
        let movies: [Movie]
        let isLoading: Bool
    }

    private static func select(state: AppState) -> State {
        .init(
            movies: state.searchState.moviesToDisplay,
            isLoading: state.searchState.isLoading
        )
    }

    func newState(state: State) {
        movies = state.movies

        tableView.tableFooterView = state.isLoading
            ? loadingIndicatorView
            : UIView()
    }
}

extension SearchMoviesViewController: Instantiable {
    static var storyboard: Storyboard { .search }
    static var storyboardID: String? { "SearchMoviesViewController" }
}
