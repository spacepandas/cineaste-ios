//
//  SearchMoviesViewController.swift
//  Cineaste
//
//  Created by Christian Braun on 02.11.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

let SHOWDETAILSEGUE = "ShowMovieDetailSegue"

class SearchMoviesViewController: UIViewController,
    UITableViewDataSource,
    UITableViewDelegate,
UISearchResultsUpdating {
    @IBOutlet weak fileprivate var searchBarView: UIView!
    @IBOutlet weak fileprivate var moviesTableView: UITableView!
    var movies: [Movie]?
    var selectedMovie: Movie?
    var searchDelayTimer: Timer?
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
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        loadRecentMovies()

        if #available(iOS 11.0, *) {
            navigationItem.searchController = resultSearchController
            navigationItem.hidesSearchBarWhenScrolling = false
            searchBarView.removeFromSuperview()

            //add style for searchField - only in iOS 11
            guard let textfield = resultSearchController.searchBar.value(forKey: "searchField") as? UITextField,
                let backgroundview = textfield.subviews.first else { return }
            backgroundview.backgroundColor = .basicWhite
            backgroundview.layer.cornerRadius = 10
            backgroundview.clipsToBounds = true
        } else {
            searchBarView.addSubview(resultSearchController.searchBar)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        } else {
            // Fallback on earlier versions
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

    // MARK: - TableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchMoviesTableViewCell.identifier, for: indexPath) as? SearchMoviesTableViewCell else {
            fatalError("Unable to dequeue cell for identifier: \(SearchMoviesTableViewCell.identifier)")
        }
        guard let movies = movies else { fatalError("no data for cell found") }

        cell.configure(with: movies[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movies = movies else { return }
        selectedMovie = movies[indexPath.row]

        DispatchQueue.main.async {
            self.resultSearchController.isActive = false
        }

        performSegue(withIdentifier: SHOWDETAILSEGUE, sender: self)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case SHOWDETAILSEGUE?:
            let vc = segue.destination as? MovieDetailViewController
            vc?.movie = selectedMovie
        default:
            // Fallthrough
            break
        }
    }

    // MARK: - Actions

    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - UISearchResultUpdating

    internal func updateSearchResults(for searchController: UISearchController) {
        searchDelayTimer?.invalidate()
        searchDelayTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) {[weak self]_ in
            self?.loadMovies(forQuery: searchController.searchBar.text)
        }
    }

    // MARK: - Load data

    fileprivate func loadRecentMovies() {
        Webservice.load(resource: Movie.latestReleases()) {[weak self] movies, _ in
            self?.movies = movies
            DispatchQueue.main.async {
                self?.moviesTableView.reloadData()
            }
        }
    }

    fileprivate func loadMovies(forQuery query: String?) {
        if let query = query, !query.isEmpty {
            Webservice.load(resource: Movie.search(withQuery: query)) {[weak self] movies, _ in
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.moviesTableView.reloadData()
                }
            }
        } else {
            loadRecentMovies()
        }
    }
}
