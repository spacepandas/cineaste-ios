//
//  MoviesViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 01.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit
import CoreData

class MoviesViewController: UIViewController {
    var category: MyMovieListCategory = .wantToSee {
        didSet {
            title = category.title

            if fetchedResultsManager.controller == nil {
                fetchedResultsManager.delegate = self
                fetchedResultsManager.setup(with: category.predicate) {
                    myMoviesTableView.reloadData()
                }
            }
        }
    }

    @IBOutlet var myMoviesTableView: UITableView! {
        didSet {
            myMoviesTableView.dataSource = self
            myMoviesTableView.delegate = self
            myMoviesTableView.tableFooterView = UIView()
            myMoviesTableView.backgroundColor = UIColor.basicBackground
        }
    }

    var fetchedResultsManager = FetchedResultsManager()
    private var selectedMovie: StoredMovie?
}

// MARK: - UITableViewDataSource

extension MoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let fetchedObjects = fetchedResultsManager.controller?.fetchedObjects else {
            return 1
        }
        return fetchedObjects.isEmpty ? 1 : fetchedObjects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let fetchedObjects = fetchedResultsManager.controller?.fetchedObjects, !fetchedObjects.isEmpty {
            switch category {
            case .wantToSee:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: WantToSeeListCell.identifier, for: indexPath) as? WantToSeeListCell
                    else {
                        fatalError("Unable to dequeue cell for identifier: \(WantToSeeListCell.identifier)")
                }

                cell.configure(with: fetchedObjects[indexPath.row])

                return cell
            case .seen:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SeenListCell.identifier, for: indexPath) as? SeenListCell
                    else {
                        fatalError("Unable to dequeue cell for identifier: \(SeenListCell.identifier)")
                }

                cell.configure(with: fetchedObjects[indexPath.row])

                return cell
            }
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyMoviesCell.identifier, for: indexPath) as? EmptyMoviesCell
                else {
                    fatalError("Unable to dequeue cell for identifier: \(EmptyMoviesCell.identifier)")
            }

            cell.category = category
            cell.layer.backgroundColor = UIColor.clear.cgColor

            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension MoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let movies = fetchedResultsManager.controller?.fetchedObjects else {
            fatalError("Failure in loading fetchedObject")
        }
        selectedMovie = movies[indexPath.row]

        let movieDetailVC = MovieDetailViewController.instantiate()
        movieDetailVC.storedMovie = selectedMovie
        self.navigationController?.pushViewController(movieDetailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let movies = fetchedResultsManager.controller?.fetchedObjects, !movies.isEmpty else {
            return tableView.frame.size.height
        }

        return UITableViewAutomaticDimension
    }
}

// MARK: - FetchedResultsManagerDelegate

extension MoviesViewController: FetchedResultsManagerDelegate {
    func beginUpdate() {
        myMoviesTableView.beginUpdates()
    }
    func insertRows(at index: [IndexPath]) {
        myMoviesTableView.insertRows(at: index, with: .fade)
    }
    func deleteRows(at index: [IndexPath]) {
        myMoviesTableView.deleteRows(at: index, with: .fade)
    }
    func updateRows(at index: [IndexPath]) {
        myMoviesTableView.reloadRows(at: index, with: .fade)
    }
    func endUpdate() {
        myMoviesTableView.endUpdates()
    }
}

// MARK: - Instantiable

extension MoviesViewController: Instantiable {
    static var storyboard: Storyboard { return .main }
    static var storyboardID: String? { return "MoviesViewController" }
}
