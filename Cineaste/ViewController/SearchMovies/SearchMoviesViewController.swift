//
//  SearchMoviesViewController.swift
//  Cineaste
//
//  Created by Christian Braun on 02.11.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

class SearchMoviesViewController: UIViewController {
    @IBOutlet var loadingIndicatorView: UIView!

    var movies: [Movie] = [] {
        didSet {
            DispatchQueue.main.async {
                self.moviesTableView.reloadData()

                if self.movies.isEmpty {
                    self.moviesTableView.tableFooterView = UIView()
                }
            }
        }
    }

    var selectedMovie: Movie?
    var storageManager: MovieStorage?

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

    @IBOutlet var moviesTableView: UITableView! {
        didSet {
            moviesTableView.dataSource = self
            moviesTableView.prefetchDataSource = self
            moviesTableView.delegate = self

            moviesTableView.estimatedRowHeight = 100
            moviesTableView.rowHeight = UITableViewAutomaticDimension

            moviesTableView.backgroundColor = UIColor.clear
            moviesTableView.tableFooterView = loadingIndicatorView
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.basicBackground

        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }

        loadMovies { [weak self] movies in
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPath = moviesTableView.indexPathForSelectedRow {
            moviesTableView.deselectRow(at: indexPath, animated: true)
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

    // MARK: - Custom functions

    func configureSearchController() {
        if #available(iOS 11.0, *) {
            navigationItem.searchController = resultSearchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            moviesTableView.tableHeaderView = resultSearchController.searchBar
        }

        definesPresentationContext = true
    }

    func scrollToTopCell(withAnimation: Bool) {
        guard !movies.isEmpty else { return }

        DispatchQueue.main.async {
            self.moviesTableView.scrollToRow(at: IndexPath(row: 0, section: 0),
                                             at: .top,
                                             animated: withAnimation)
        }
    }
}

extension SearchMoviesViewController: SearchMoviesCellDelegate {
    func searchMoviesCell(didTriggerActionButtonFor movie: Movie, watched: Bool) {
        guard let storageManager = storageManager else { return }
        loadDetails(for: movie) { detailedMovie in
            guard let detailedMovie = detailedMovie else { return }
            storageManager.insertMovieItem(with: detailedMovie, watched: watched) { result in
                switch result {
                case .error:
                    DispatchQueue.main.async {
                        if self.resultSearchController.isActive {
                            self.resultSearchController.isActive = false
                        }
                        self.showAlert(withMessage: Alert.insertMovieError)
                    }
                case .success:
                    DispatchQueue.main.async {
                        if self.resultSearchController.isActive {
                            self.resultSearchController.isActive = false
                        }
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

extension SearchMoviesViewController: Instantiable {
    static var storyboard: Storyboard { return .search }
    static var storyboardID: String? { return "SearchMoviesViewController" }
}
