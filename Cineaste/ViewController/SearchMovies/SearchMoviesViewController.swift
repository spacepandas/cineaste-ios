//
//  SearchMoviesViewController.swift
//  Cineaste
//
//  Created by Christian Braun on 02.11.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

class SearchMoviesViewController: UIViewController {
    var movies: [Movie] = [] {
        didSet {
            DispatchQueue.main.async {
                self.moviesTableView.reloadData()
            }
        }
    }

    var selectedMovie: Movie?
    var storageManager: MovieStorage?

    private var searchDelayTimer: Timer?

    lazy var resultSearchController: UISearchController  = {
        let resultSearchController = UISearchController(searchResultsController: nil)
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.isActive = false
        resultSearchController.searchBar.sizeToFit()
        resultSearchController.searchResultsUpdater = self
        return resultSearchController
    }()

    @IBOutlet var moviesTableView: UITableView! {
        didSet {
            moviesTableView.dataSource = self
            moviesTableView.delegate = self

            moviesTableView.estimatedRowHeight = 100
            moviesTableView.rowHeight = UITableViewAutomaticDimension

            moviesTableView.backgroundColor = UIColor.clear
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.basicBackground

        loadRecent { [weak self] movies in
            self?.movies = movies
        }

        configureSearchController()
        registerForPreviewing(with: self, sourceView: moviesTableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if #available(iOS 11.0, *) {
            return
        } else {
            resultSearchController.searchBar.sizeToFit()
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch Segue(initWith: segue) {
        case .showMovieDetail?:
            let vc = segue.destination as? MovieDetailViewController
            vc?.storageManager = storageManager
            vc?.type = .search

            guard let selectedMovie = selectedMovie else { return }
            vc?.movie = selectedMovie
        default:
            return
        }
    }

    // MARK: - Actions

    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - SearchController

    func configureSearchController() {
        if #available(iOS 11.0, *) {
            navigationItem.searchController = resultSearchController
            navigationItem.hidesSearchBarWhenScrolling = false

            //add style for searchField - only in iOS 11
            guard let textfield = resultSearchController.searchBar.value(forKey: "searchField") as? UITextField,
                let backgroundview = textfield.subviews.first else { return }
            backgroundview.backgroundColor = .basicWhite
            backgroundview.layer.cornerRadius = 10
            backgroundview.clipsToBounds = true
        } else {
            moviesTableView.tableHeaderView = resultSearchController.searchBar
        }
        self.definesPresentationContext = true
    }

}

extension SearchMoviesViewController: UISearchResultsUpdating {
    internal func updateSearchResults(for searchController: UISearchController) {
        searchDelayTimer?.invalidate()
        searchDelayTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] _ in
            self?.loadMovies(forQuery: searchController.searchBar.text) { movies in
                self?.movies = movies
            }
        }
    }
}

extension SearchMoviesViewController: SearchMoviesCellDelegate {
    func searchMoviesCell(didTriggerActionButtonFor movie: Movie, watched: Bool) {
        guard let storageManager = storageManager else { return }
        loadDetails(for: movie) { detailedMovie in
            storageManager.insertMovieItem(with: detailedMovie, watched: watched) { result in
                switch result {
                case .error:
                    DispatchQueue.main.async {
                        self.showAlert(withMessage: Alert.insertMovieError)
                    }
                case .success:
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

// MARK: - 3D Touch

extension SearchMoviesViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let detailVC = MovieDetailViewController.instantiate()
        guard let path = moviesTableView.indexPathForRow(at: location),
            movies.count > path.section
            else { return nil }

        detailVC.movie = movies[path.section]
        detailVC.storageManager = storageManager
        detailVC.type = .search
        return detailVC
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}

extension SearchMoviesViewController: Instantiable {
    static var storyboard: Storyboard { return .search }
    static var storyboardID: String? { return "SearchMoviesViewController" }
}
