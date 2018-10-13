//
//  MovieMatchViewController.swift
//  Cineaste
//
//  Created by Christian Braun on 26.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class MovieMatchViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self

            tableView.allowsSelection = false
            tableView.backgroundColor = UIColor.basicBackground

            tableView.tableFooterView = UIView()
        }
    }

    private var moviesWithNumber: [(NearbyMovie, Int)] = []
    private var totalNumberOfPeople: Int = 0

    private var storageManager: MovieStorage?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = String.resultsForMovieNight
    }

    func configure(with messagesToMatch: [NearbyMessage], storageManager: MovieStorage) {
        totalNumberOfPeople = messagesToMatch.count
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
    }
}

extension MovieMatchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesWithNumber.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieMatchCell = tableView.dequeueCell(identifier: MovieMatchCell.identifier)

        let movieWithNumber = moviesWithNumber[indexPath.row]
        cell.configure(with: movieWithNumber.0,
                       numberOfMatches: movieWithNumber.1,
                       amountOfPeople: totalNumberOfPeople,
                       delegate: self)

        return cell
    }
}

extension MovieMatchViewController: MovieMatchTableViewCellDelegate {
    func movieMatchTableViewCell(sender: MovieMatchCell, didSelectMovie movie: NearbyMovie, withPoster poster: UIImage?) {
        let movieForRequest = Movie(id: movie.id,
                                    title: movie.title)
        Webservice.load(resource: movieForRequest.get) { result in
            switch result {
            case .success(let movie):
                movie.poster = poster ?? movie.poster

                guard let storageManager = self.storageManager else { return }
                storageManager.insertMovieItem(with: movie, watched: true)

                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            case .error:
                self.showAlert(withMessage: Alert.loadingDataError)
            }
        }
    }
}
