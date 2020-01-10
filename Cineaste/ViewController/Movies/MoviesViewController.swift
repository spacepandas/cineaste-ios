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
    @IBOutlet private weak var empyListTitle: UILabel!
    @IBOutlet private weak var emptyListLabel: UILabel!
    @IBOutlet private weak var emptyListAddMovieButton: UIButton!
    @IBOutlet private var emptyViewStackView: UIStackView!

    @IBOutlet private weak var startMovieNightButton: UIBarButtonItem!
    @IBOutlet private weak var addMovieButton: UIBarButtonItem!

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

        view.backgroundColor = UIColor.cineListBackground

        startMovieNightButton.accessibilityLabel = .startMovieNight
        startMovieNightButton.accessibilityIdentifier = "StartMovieNight.Button"
        addMovieButton.accessibilityLabel = .addMovieTitle
        addMovieButton.accessibilityIdentifier = "AddMovie.Button"

        registerForPreviewing(with: self, sourceView: tableView)

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
        performSegue(withIdentifier: Segue.showSearchFromMovieList.rawValue, sender: nil)
    }

    @IBAction func movieNightButtonTouched() {
        if UserDefaults.standard.username == nil {
            let alert = UsernameAlert.askForUsernameAlertController(presenter: self, onSave: {
                self.performSegue(
                    withIdentifier: Segue.showMovieNight.rawValue,
                    sender: nil
                )
            }, onCancel: nil) // swiftlint:disable:this multiline_arguments_brackets
            present(alert, animated: true)
        } else {
            performSegue(withIdentifier: Segue.showMovieNight.rawValue, sender: nil)
        }
    }

    @objc
    func refreshMovies() {
        MovieRefresher.refresh(movies: movies) {
            self.tableView.refreshControl?.endRefreshing()
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
        empyListTitle.textColor = .cineEmptyListDescription
        empyListTitle.text = .noContentTitle
        emptyListAddMovieButton.backgroundColor = .cineButton
        emptyListAddMovieButton.setTitleColor(.white, for: .normal)
        emptyListAddMovieButton.setTitle(.addMovieTitle, for: .normal)
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

    func showEmptyStateIfNeeded(_ showEmptyState: Bool) {
        DispatchQueue.main.async {
            self.tableView.backgroundView?.alpha = showEmptyState ? 1 : 0
            self.tableView.backgroundView?.isHidden = !showEmptyState
        }
    }
}

// MARK: - UITextFieldDelegate

extension MoviesViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }

        let entryLength = text.count + string.count - range.length
        UsernameAlert.saveAction?.isEnabled = entryLength > 0

        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        UsernameAlert.saveAction?.isEnabled = false
        return true
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
        showEmptyStateIfNeeded(sortedMovies.isEmpty)
    }
}

// MARK: - Instantiable

extension MoviesViewController: Instantiable {
    static var storyboard: Storyboard { .movieList }
    static var storyboardID: String? { "MoviesViewController" }
}
