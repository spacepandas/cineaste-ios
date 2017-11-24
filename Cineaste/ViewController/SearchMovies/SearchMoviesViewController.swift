//
//  SearchMoviesViewController.swift
//  Cineaste
//
//  Created by Christian Braun on 02.11.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

let SHOWDETAILSEGUE = "ShowMovieDetailSegue"

class SearchMoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak fileprivate var moviesTableView: UITableView!
    var movies: [Movie]?
    var selectedMovie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        loadRecentMovies()
    }

    // MARK: - TableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchMoviesTableViewCell.IDENTIFIER, for: indexPath) as? SearchMoviesTableViewCell else {
            fatalError("Unable to dequeue cell for identifier: \(SearchMoviesTableViewCell.IDENTIFIER)")
        }
        cell.movie = movies?[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movies = movies else { return }
        selectedMovie = movies[indexPath.row]
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

    // MARK: - Load data

    fileprivate func loadRecentMovies() {
        Webservice.load(resource: Movie.latestReleases()) {[weak self] movies, _ in
            self?.movies = movies
            DispatchQueue.main.async {
                self?.moviesTableView.reloadData()
            }
        }
    }
}
