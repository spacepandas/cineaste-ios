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

    @IBOutlet private weak var startMovieNightButton: UIBarButtonItem!

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

    private var saveAction: UIAlertAction?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.basicBackground

        emptyListLabel.textColor = .accentTextOnBlack
        empyListTitle.textColor = .accentTextOnBlack
        empyListTitle.text = .noContentTitle

        startMovieNightButton.title = .startMovieNight

        registerForPreviewing(with: self, sourceView: tableView)

        configureTableView()
        configureSearchController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }

        store.subscribe(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        resultSearchController.isActive = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        store.unsubscribe(self)
    }

    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if #available(iOS 11.0, *) {
            return
        } else {
            resultSearchController.searchBar.sizeToFit()
        }
    }

    // MARK: - Action

    @IBAction func movieNightButtonTouched() {
        if UserDefaultsManager.getUsername() == nil {
            askForUsername()
        } else {
            performSegue(withIdentifier: Segue.showMovieNight.rawValue, sender: nil)
        }
    }

    // MARK: - Configuration

    private func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.basicBackground

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
        if #available(iOS 11.0, *) {
            navigationItem.searchController = resultSearchController
            navigationItem.hidesSearchBarWhenScrolling = true
        } else {
            tableView.tableHeaderView = resultSearchController.searchBar
        }

        definesPresentationContext = true
    }

    // MARK: - Custom functions

    func showEmptyState(_ emptyState: Bool, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: {
            self.tableView.backgroundView?.alpha = emptyState ? 1 : 0
        }, completion: { _ in
            self.tableView.backgroundView?.isHidden = !emptyState
            completion?()
        })
    }

    private func askForUsername() {
        let alert = UIAlertController(title: Alert.insertUsername.title,
                                      message: Alert.insertUsername.message,
                                      preferredStyle: .alert)
        saveAction = UIAlertAction(title: Alert.insertUsername.action, style: .default) { _ in
            guard let textField = alert.textFields?[0], let username = textField.text else {
                return
            }
            UserDefaultsManager.setUsername(username)
            self.performSegue(withIdentifier: Segue.showMovieNight.rawValue, sender: nil)
        }

        if let saveAction = saveAction {
            saveAction.isEnabled = false
            alert.addAction(saveAction)
        }

        if let cancelTitle = Alert.insertUsername.cancel {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)
            alert.addAction(cancelAction)
        }

        alert.addTextField { textField in
            textField.placeholder = String.usernamePlaceholder
            textField.delegate = self
        }

        present(alert, animated: true)
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
        saveAction?.isEnabled = entryLength > 0 ? true : false

        return true
    }
}

extension MoviesViewController: StoreSubscriber {
    func newState(state: AppState) {
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
