//
//  SearchMoviesViewController.swift
//  Cineaste
//
//  Created by Christian Braun on 02.11.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

class SearchMoviesViewController: UIViewController {
    @IBOutlet var moviesTableView: UITableView! {
        didSet {
            moviesTableView.dataSource = dataSource
            moviesTableView.delegate = self
        }
    }

    private var selectedMovie: Movie?
    private var searchDelayTimer: Timer?

    private let dataSource = SearchMoviesSource()

    lazy var resultSearchController: UISearchController  = {
        let resultSearchController = UISearchController(searchResultsController: nil)
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.isActive = true
        resultSearchController.searchBar.sizeToFit()
        resultSearchController.searchResultsUpdater = self
        return resultSearchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadRecent { [weak self] movies in
            self?.dataSource.movies = movies
            DispatchQueue.main.async {
                self?.moviesTableView.reloadData()
            }
        }

        configureSearchController()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
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
        guard let identifier = Segue(initWith: segue) else {
            fatalError("unable to use Segue enum")
        }

        switch identifier {
        case .showMovieDetail:
            let vc = segue.destination as? MovieDetailViewController
            vc?.movie = selectedMovie
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
            self.definesPresentationContext = true
        }
    }

    // MARK: - Load data

    fileprivate func loadRecent(movies handler: @escaping ([Movie]) -> Void) {
        Webservice.load(resource: Movie.latestReleases()) { result in
            guard case let .success(movies) = result else {
                self.showAlert(withMessage: Alert.loadingDataError)
                handler([])
                return
            }
            handler(movies)
        }
    }

    fileprivate func loadMovies(forQuery query: String?, handler: @escaping ([Movie]) -> Void) {
        if let query = query, !query.isEmpty {
            Webservice.load(resource: Movie.search(withQuery: query)) { result in
                guard case let .success(movies) = result else {
                    self.showAlert(withMessage: Alert.loadingDataError)
                    handler([])
                    return
                }
                handler(movies)
            }
        } else {
            loadRecent { [weak self] movies in
                self?.dataSource.movies = movies
                DispatchQueue.main.async {
                    self?.moviesTableView.reloadData()
                }
            }
        }
    }
}

extension SearchMoviesViewController: UISearchResultsUpdating {
    internal func updateSearchResults(for searchController: UISearchController) {
        searchDelayTimer?.invalidate()
        searchDelayTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] _ in
            self?.loadMovies(forQuery: searchController.searchBar.text) { movies in
                self?.dataSource.movies = movies
                DispatchQueue.main.async {
                    self?.moviesTableView.reloadData()
                }
            }
        }
    }
}

extension SearchMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedMovie = dataSource.movies[indexPath.row]

        DispatchQueue.main.async {
            self.resultSearchController.isActive = false
        }

        perform(segue: .showMovieDetail, sender: self)
    }
}

extension SearchMoviesViewController: Instantiable {
    static var storyboard: Storyboard { return .search }
    static var storyboardID: String? { return "SearchMoviesViewController" }
}
