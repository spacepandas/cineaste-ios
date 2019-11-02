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
    @IBOutlet weak var emptyListAddMovieButton: UIButton!
    @IBOutlet weak var emptyViewStackView: UIStackView!

    @IBOutlet private weak var startMovieNightButton: UIBarButtonItem!
    @IBOutlet private weak var addMovieButton: UIBarButtonItem!

    var category: MovieListCategory = .watchlist {
        didSet {
            title = category.title
            emptyListLabel.text = String.title(for: category)

            guard oldValue != category else { return }

            movies = movies.filter { $0.watched == category.watched }
        }
    }

    var movies: [Movie] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.showEmptyState(self.movies.isEmpty)
                self.updateShortcutItems()
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

        emptyListLabel.textColor = .cineEmptyListDescription
        empyListTitle.textColor = .cineEmptyListDescription
        empyListTitle.text = .noContentTitle
        emptyListAddMovieButton.backgroundColor = .cineButton
        emptyListAddMovieButton.setTitleColor(.white, for: .normal)
        emptyListAddMovieButton.setTitle(.addMovieTitle, for: .normal)

        emptyViewStackView.setCustomSpacing(30, after: emptyListLabel)

        startMovieNightButton.accessibilityLabel = .startMovieNight
        startMovieNightButton.accessibilityIdentifier = "StartMovieNight.Button"
        addMovieButton.accessibilityLabel = .addMovieTitle
        addMovieButton.accessibilityIdentifier = "AddMovie.Button"

        registerForPreviewing(with: self, sourceView: tableView)

        configureTableView()
        configureSearchController()
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
        return .lightContent
    }

    // MARK: - Action

    @IBAction func addMovieButtonTouched(_ sender: Any) {
        performSegue(withIdentifier: Segue.showSearchFromMovieList.rawValue, sender: nil)
    }

    @IBAction func movieNightButtonTouched() {
        if UsernamePersistence.username == nil {
            let alert = UsernameAlert.askForUsernameAlertController(presenter: self, onSave: {
                self.performSegue(withIdentifier: Segue.showMovieNight.rawValue,
                                  sender: nil)
            }, onCancel: nil)
            present(alert, animated: true)
        } else {
            performSegue(withIdentifier: Segue.showMovieNight.rawValue, sender: nil)
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
        refreshControl.attributedTitle =
            NSAttributedString(string: String.refreshMovieData,
                               attributes: attributes)

        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
    }

    @objc
    func refreshMovies() {
        MovieRefresher().refresh(movies: movies) {
            self.tableView.refreshControl?.endRefreshing()
        }
    }

    private func configureSearchController() {
        navigationItem.searchController = resultSearchController
        navigationItem.hidesSearchBarWhenScrolling = true

        definesPresentationContext = true
    }

    // MARK: - Custom functions

    func showEmptyState(_ emptyState: Bool, completion: (() -> Void)? = nil) {
        let isEmpty = emptyState

        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, animations: {
                self.tableView.backgroundView?.alpha = isEmpty ? 1 : 0
            }, completion: { _ in
                self.tableView.backgroundView?.isHidden = !isEmpty
                completion?()
            })
        }
    }

    private func updateShortcutItems() {
        var shortcuts = UIApplication.shared.shortcutItems ?? []

        //initially instantiate shortcuts
        if shortcuts.isEmpty {
            let watchlistIcon = UIApplicationShortcutIcon(templateImageName: "watchlist")
            let watchlistShortcut =
                UIApplicationShortcutItem(type: ShortcutIdentifier.watchlist.rawValue,
                                          localizedTitle: String.watchlist,
                                          localizedSubtitle: nil,
                                          icon: watchlistIcon,
                                          userInfo: nil)

            let seenIcon = UIApplicationShortcutIcon(templateImageName: "seen")
            let seenShortcut =
                UIApplicationShortcutItem(type: ShortcutIdentifier.seen.rawValue,
                                          localizedTitle: String.seen,
                                          localizedSubtitle: nil,
                                          icon: seenIcon,
                                          userInfo: nil)

            shortcuts = [watchlistShortcut, seenShortcut]
            UIApplication.shared.shortcutItems = shortcuts
        }

        let index = category == .watchlist ? 0 : 1
        let existingItem = shortcuts[index]

        //only update if value changed
        let newShortcutSubtitle =
            movies.isEmpty
            ? nil
            : String.movies(for: movies.count)
        if existingItem.localizedSubtitle != newShortcutSubtitle {
            //swiftlint:disable:next force_cast
            let mutableShortcutItem = existingItem.mutableCopy() as! UIMutableApplicationShortcutItem
            mutableShortcutItem.localizedSubtitle = newShortcutSubtitle

            shortcuts[index] = mutableShortcutItem

            UIApplication.shared.shortcutItems = shortcuts
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
        return .init(movies: state.movies)
    }

    func newState(state: State) {
        movies = state.movies
            .filter { $0.watched == category.watched }
            .sorted(by: category.watched
                ? SortDescriptor.sortByWatchedDate
                : SortDescriptor.sortByListPositionAndTitle)
    }
}

// MARK: - Instantiable

extension MoviesViewController: Instantiable {
    static var storyboard: Storyboard { return .movieList }
    static var storyboardID: String? { return "MoviesViewController" }
}
