//
//  MovieMatchViewController.swift
//  Cineaste
//
//  Created by Christian Braun on 26.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class MovieMatchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self

            tableView.allowsSelection = false
            tableView.backgroundColor = UIColor.basicBackground

            tableView.tableFooterView = UIView()
        }
    }

    var moviesWithNumber: [(NearbyMovie, Int)] = []
    var totalNumberOfPeople: Int = 0

    var storageManager: MovieStorage?

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
