//
//  MovieMatchViewController.swift
//  Cineaste
//
//  Created by Christian Braun on 26.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit
import ReSwift

class MovieMatchViewController: UITableViewController {
    private lazy var resultSearchController: SearchController = {
        let resultSearchController = SearchController(searchResultsController: nil)
        resultSearchController.searchResultsUpdater = self
        return resultSearchController
    }()

    private(set) var totalNumberOfPeople: Int = 0
    var showAllTogetherMovies: Bool {
        totalNumberOfPeople != 1
    }

    private var moviesWithNumber: [(NearbyMovie, Int)] = []
    private(set) var filteredMoviesWithNumber: [(movie: NearbyMovie, number: Int)] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureSearchController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        store.subscribe(self) { subscription in
            subscription
                .select(MovieMatchViewController.select)
                .skipRepeats()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        store.unsubscribe(self)
    }

    // MARK: - Configuration

    private func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.cineListBackground

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
    }

    private func configureSearchController() {
        navigationItem.searchController = resultSearchController
        navigationItem.hidesSearchBarWhenScrolling = true

        definesPresentationContext = true
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
        let movieForRequest = Movie(id: movie.id)
        Webservice.load(resource: movieForRequest.get) { result in
            switch result {
            case .success(let movie):
                DispatchQueue.main.async {
                    store.dispatch(updateMovie(with: movie, markAsWatched: true))

                    if self.resultSearchController.isActive {
                        self.resultSearchController.isActive = false
                    }

                    self.dismiss(animated: true)
                }
            case .failure:
                self.showAlert(withMessage: Alert.loadingDataError)
            }
        }
    }
}

extension MovieMatchViewController: StoreSubscriber {
    struct State: Equatable {
        let title: String
        let nearbyMessages: [NearbyMessage]
    }

    private static func select(state: AppState) -> State {
        let messages = state.nearbyState.selectedNearbyMessages

        let title: String
        if messages.count == 1 {
            title = messages.first?.userName ?? ""
        } else {
            title = String.allResultsForMovieNight
        }

        return .init(
            title: title,
            nearbyMessages: messages
        )
    }

    func newState(state: State) {
        title = state.title
        totalNumberOfPeople = state.nearbyMessages.count

        let sortedMoviesWithNumber = getSortedMoviesWithNumber(from: state.nearbyMessages)
        moviesWithNumber = sortedMoviesWithNumber
        filteredMoviesWithNumber = sortedMoviesWithNumber
    }

    private func getSortedMoviesWithNumber(from messagesToMatch: [NearbyMessage]) -> [(NearbyMovie, Int)] {
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

        let sortedMoviesWithNumber: [(NearbyMovie, Int)] = moviesWithNumberDict.sorted {
            // first sort by number, second sort by title
            ($0.value, $1.key.title) > ($1.value, $0.key.title)
        }

        return sortedMoviesWithNumber
    }
}

extension MovieMatchViewController: Instantiable {
    static var storyboard: Storyboard { return .movieNight }
    static var storyboardID: String? { return "MovieMatchViewController" }
}
