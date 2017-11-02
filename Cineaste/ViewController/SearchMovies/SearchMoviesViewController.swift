//
//  SearchMoviesViewController.swift
//  Cineaste
//
//  Created by Christian Braun on 02.11.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

class SearchMoviesViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var moviesTableView: UITableView!
    var movies:[Movie]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesTableView.dataSource = self
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchMoviesTableViewCell.CELL_IDENTIFIER, for: indexPath) as? SearchMoviesTableViewCell else {
            fatalError("Unable to dequeue cell for identifier: \(SearchMoviesTableViewCell.CELL_IDENTIFIER)")
        }
        cell.movie = movies?[indexPath.row]
        return cell
    }
    
    // MARK: - Actions
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Load data
    
    fileprivate func loadRecentMovies() {
        Webservice.load(resource: Movie.latestReleases()){[weak self] movies, error in
            self?.movies = movies
            DispatchQueue.main.async {
                self?.moviesTableView.reloadData()
            }
        }
    }
}
