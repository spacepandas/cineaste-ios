//
//  MovieMatchViewController.swift
//  Cineaste
//
//  Created by Christian Braun on 26.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

struct NearbyMovieWithOccurrence {
    var occurances: Int = 1
    var nearbyMovie: NearbyMovie
}

class MovieMatchViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var matchedMoviesTableView: UITableView!

    fileprivate var nearbyMovieOccurrences: [NearbyMovie: NearbyMovieWithOccurrence] = [:]
    fileprivate var sortedMoviesWithOccurrence = [NearbyMovieWithOccurrence]()
    fileprivate var totalNumberOfPeople: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        matchedMoviesTableView.dataSource = self
        matchedMoviesTableView.backgroundColor = UIColor.basicBackground
    }

    func configure(with messagesToMatch: [NearbyMessage]) {
        totalNumberOfPeople = messagesToMatch.count
        for message in messagesToMatch {
            for movie in message.movies {
                if nearbyMovieOccurrences[movie] == nil {
                    nearbyMovieOccurrences[movie] = NearbyMovieWithOccurrence(occurances: 1, nearbyMovie: movie)
                } else {
                    nearbyMovieOccurrences[movie]?.occurances += 1
                }
            }
        }

        orderMatchedMoviesByOccurance()
    }

    fileprivate func orderMatchedMoviesByOccurance() {
        let movies = Array(nearbyMovieOccurrences.values)
        sortedMoviesWithOccurrence = movies.sorted { leftSide, rightSide -> Bool in
            leftSide.occurances > rightSide.occurances
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedMoviesWithOccurrence.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieMatchTableViewCell.cellIdentifier, for: indexPath)
            as? MovieMatchTableViewCell else {
                fatalError("Unable to dequeue cell with identifier \(MovieMatchTableViewCell.cellIdentifier)")
        }

        cell.configure(with: sortedMoviesWithOccurrence[indexPath.row], amountOfPeople: totalNumberOfPeople)

        return cell
    }
}
