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

            //only update if category changed
            guard oldValue != category else { return }
            if fetchedResultsManager.controller == nil {
                fetchedResultsManager.setup(with: category.predicate) {
                    myMoviesTableView.reloadData()
                }
            } else {
                fetchedResultsManager.update(for: category.predicate) {
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

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchedResultsManager.delegate = self
        fetchedResultsManager.setup(with: category.predicate) {
            myMoviesTableView.reloadData()
        }
    }
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyMovieListCell.identifier, for: indexPath) as? MyMovieListCell
                else {
                    fatalError("Unable to dequeue cell for identifier: \(MyMovieListCell.identifier)")
            }

            cell.configure(with: fetchedObjects[indexPath.row])

            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyMoviesCell.identifier, for: indexPath) as? EmptyMoviesCell
                else {
                    fatalError("Unable to dequeue cell for identifier: \(EmptyMoviesCell.identifier)")
            }

            cell.category = category
            cell.selectionStyle = .none
            cell.layer.backgroundColor = UIColor.clear.cgColor

            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension MoviesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let fetchedObjects = fetchedResultsManager.controller?.fetchedObjects, !fetchedObjects.isEmpty else { return nil }
        return indexPath
    }

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
    func moveRow(at index: IndexPath, to newIndex: IndexPath) {
        myMoviesTableView.moveRow(at: index, to: newIndex)
    }
    func endUpdate() {
        myMoviesTableView.endUpdates()
    }
}

// MARK: - Instantiable

extension MoviesViewController: Instantiable {
    static var storyboard: Storyboard { return .movieList }
    static var storyboardID: String? { return "MoviesViewController" }
}
