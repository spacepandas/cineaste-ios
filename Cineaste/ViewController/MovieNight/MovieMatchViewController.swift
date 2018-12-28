//
//  MovieMatchViewController.swift
//  Cineaste
//
//  Created by Christian Braun on 26.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class MovieMatchViewController: UITableViewController {
    private var moviesWithNumber: [(NearbyMovie, Int)] = []
    private var filteredMoviesWithNumber: [(NearbyMovie, Int)] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var totalNumberOfPeople: Int = 0
    private var showAllTogetherMovies: Bool = false
    private var storageManager: MovieStorageManager?

    private lazy var resultSearchController: SearchController = {
        let resultSearchController = SearchController(searchResultsController: nil)
        resultSearchController.searchResultsUpdater = self
        return resultSearchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureSearchController()
    }

    func configure(with userName: String, messagesToMatch: [NearbyMessage], storageManager: MovieStorageManager) {
        title = userName
        totalNumberOfPeople = messagesToMatch.count
        showAllTogetherMovies = totalNumberOfPeople != 1
        self.storageManager = storageManager

        var moviesWithNumberDict: [NearbyMovie: Int] = [:]

        for movies in messagesToMatch {
            for movie in movies.movies {
                if let number = moviesWithNumberDict[movie] {
                    moviesWithNumberDict[movie] = number + 1
                } else {
                    moviesWithNumberDict[movie] = 1
                }
            }
        }

        moviesWithNumber = moviesWithNumberDict.sorted {
            // first sort by number, second sort by title
            ($0.value, $1.key.title) > ($1.value, $0.key.title)
        }
        filteredMoviesWithNumber = moviesWithNumber
    }

    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if #available(iOS 11.0, *) {
            return
        } else {
            resultSearchController.searchBar.sizeToFit()
        }
    }

    // MARK: - Configuration

    private func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.basicBackground

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
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

    // MARK: TableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMoviesWithNumber.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieMatchCell = tableView.dequeueCell(identifier: MovieMatchCell.identifier)

        let movieWithNumber = filteredMoviesWithNumber[indexPath.row]
        if showAllTogetherMovies {
            cell.configure(with: movieWithNumber.0,
                           numberOfMatches: movieWithNumber.1,
                           amountOfPeople: totalNumberOfPeople,
                           delegate: self)
        } else {
            cell.configure(with: movieWithNumber.0,
                           delegate: self)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nearbyMovie = filteredMoviesWithNumber[indexPath.row].0

        guard let storageManager = storageManager
            else { return }

        let vc = MovieDetailViewController.instantiate()

        let networkMovie = Movie(id: nearbyMovie.id, title: nearbyMovie.title)
        vc.configure(with: .network(networkMovie),
                     type: .search,
                     storageManager: storageManager)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MovieMatchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }

        if !searchText.isEmpty {
            filteredMoviesWithNumber = moviesWithNumber.filter { $0.0.title.contains(searchText) }
        } else {
            filteredMoviesWithNumber = moviesWithNumber
        }
    }
}

extension MovieMatchViewController: MovieMatchTableViewCellDelegate {
    func movieMatchTableViewCell(didSelectMovie movie: NearbyMovie, withPoster poster: UIImage?) {
        let movieForRequest = Movie(id: movie.id,
                                    title: movie.title)
        Webservice.load(resource: movieForRequest.get) { result in
            switch result {
            case .success(let movie):
                movie.poster = poster ?? movie.poster

                guard let storageManager = self.storageManager else { return }
                storageManager.insertMovieItem(with: movie, watched: true) { result in
                    DispatchQueue.main.async {
                        if self.resultSearchController.isActive {
                            self.resultSearchController.isActive = false
                        }

                        switch result {
                        case .error:
                            self.showAlert(withMessage: Alert.insertMovieError)
                        case .success:
                            self.dismiss(animated: true)
                        }
                    }
                }
            case .error:
                self.showAlert(withMessage: Alert.loadingDataError)
            }
        }
    }
}

extension MovieMatchViewController: Instantiable {
    static var storyboard: Storyboard { return .movieNight }
    static var storyboardID: String? { return "MovieMatchViewController" }
}
