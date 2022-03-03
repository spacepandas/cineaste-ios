//
//  MoviesViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 01.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit
import ReSwift

class MoviesViewController: UITableViewController {
    @IBOutlet private weak var emptyView: UIView!
    @IBOutlet private weak var emptyListTitle: UILabel!
    @IBOutlet private weak var emptyListLabel: UILabel!
    @IBOutlet private weak var emptyListAddMovieButton: UIButton!
    @IBOutlet private var emptyViewStackView: UIStackView!

    var category: MovieListCategory = .watchlist {
        didSet {
            guard oldValue != category else { return }

            updateUI(for: category)
            movies = movies.filter { $0.watched == category.watched }
        }
    }

    var movies: [Movie] = []
    var filteredMovies: [Movie] = [] {
        didSet {
            guard oldValue != filteredMovies else { return }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    private lazy var resultSearchController: SearchController = {
        let resultSearchController = SearchController(searchResultsController: nil)
        resultSearchController.searchResultsUpdater = self
        return resultSearchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = .top
        extendedLayoutIncludesOpaqueBars = true

        view.backgroundColor = UIColor.cineListBackground

        updateUI(for: category)

        configureTableView()
        configureSearchController()
        configureEmptyState()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }

        store.subscribe(self) { subscription in
            subscription
                .select(MoviesViewController.select)
                .skipRepeats()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        resultSearchController.isActive = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        store.unsubscribe(self)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    // MARK: - Action

    @IBAction func addMovieButtonTouched() {
        tabBarController?.selectedIndex = 2
    }

    @objc
    func refreshMovies() {
        MovieRefresher.refresh(movies: movies) { progress in
            if progress == 1 {
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }

    // MARK: - Configuration

    private func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.cineListBackground

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80

        tableView.backgroundView = emptyView

        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white

        let attributes = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .callout),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        refreshControl.attributedTitle = NSAttributedString(
            string: String.refreshMovieData,
            attributes: attributes
        )

        refreshControl.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    private func configureSearchController() {
        navigationItem.searchController = resultSearchController
        navigationItem.hidesSearchBarWhenScrolling = true

        definesPresentationContext = true
    }

    private func configureEmptyState() {
        emptyListLabel.textColor = .cineEmptyListDescription
        emptyListLabel.text = String.title(for: category)
        emptyListTitle.textColor = .cineEmptyListDescription
        emptyListTitle.text = .noContentTitle
        emptyListAddMovieButton.backgroundColor = .cineButton
        emptyListAddMovieButton.setTitleColor(.white, for: .normal)
        emptyListAddMovieButton.setTitle(.discoverMovieTitle, for: .normal)
        emptyViewStackView.setCustomSpacing(30, after: emptyListLabel)
    }

    // MARK: - Custom functions

    private func updateUI(for category: MovieListCategory) {
        title = category.title
        emptyListLabel.text = String.title(for: category)
        resultSearchController.searchBar.placeholder = .searchInCategoryPlaceholder
            + " "
            + category.title
    }
}

extension MoviesViewController: StoreSubscriber {
    struct State: Equatable {
        let movies: Set<Movie>
    }

    private static func select(state: AppState) -> State {
        .init(movies: state.movies)
    }

    func newState(state: State) {
        let sortedMovies = state.movies
            .filter { $0.watched == category.watched }
            .sorted(
                by: category.watched
                ? SortDescriptor.sortByWatchedDate
                : SortDescriptor.sortByListPositionAndTitle
        )

        movies = sortedMovies
        filteredMovies = sortedMovies

        tableView.backgroundView = sortedMovies.isEmpty
            ? emptyView
            : nil
    }
}

// MARK: - Instantiable

extension MoviesViewController: Instantiable {
    static var storyboard: Storyboard { .movieList }
    static var storyboardID: String? { "MoviesViewController" }
}
