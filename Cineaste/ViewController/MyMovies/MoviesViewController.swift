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
    var category: MovieListCategory = .wantToSee {
        didSet {
            title = category.title

            emptyListLabel.text =
                NSLocalizedString("Du hast keine Filme auf deiner \(category.tabBarTitle). Füge doch einen neuen Titel hinzu.",
                    comment: "Description for empty movie list")
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

    @IBOutlet weak var emptyListLabel: UILabel!
    @IBOutlet var myMoviesTableView: UITableView! {
        didSet {
            myMoviesTableView.dataSource = self
            myMoviesTableView.delegate = self
            myMoviesTableView.tableFooterView = UIView()
            myMoviesTableView.backgroundColor = UIColor.basicBackground
        }
    }

    let fetchedResultsManager = FetchedResultsManager()
    let storageManager = MovieStorage()
    private var selectedMovie: StoredMovie?

    let deleteActionTitle = NSLocalizedString("Löschen", comment: "Title for delete swipe action")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.basicBackground
        fetchedResultsManager.delegate = self
        fetchedResultsManager.setup(with: category.predicate) {
            myMoviesTableView.reloadData()
            hideTableViewIfEmpty()
        }
    }

    // MARK: - Private
    fileprivate func hideTableViewIfEmpty() {
        let hideTableView =
            self.fetchedResultsManager.controller?.fetchedObjects?.isEmpty
            ?? true

        DispatchQueue.main.async {
            UIView.animate(
                withDuration: 0.2,
                animations: {
                    self.myMoviesTableView.alpha = hideTableView ? 0 : 1
            },
                completion: { _ in
                    self.myMoviesTableView.isHidden = hideTableView
            })
        }
    }
}

// MARK: - UITableViewDataSource

extension MoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsManager.controller?.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyMovieListCell.identifier, for: indexPath) as? MyMovieListCell
            else {
                fatalError("Unable to dequeue cell for identifier: \(MyMovieListCell.identifier)")
        }

        if let controller = fetchedResultsManager.controller {
            cell.configure(with: controller.object(at: indexPath))
        }

        return cell
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
        hideTableViewIfEmpty()
    }
}

// MARK: - Instantiable

extension MoviesViewController: Instantiable {
    static var storyboard: Storyboard { return .movieList }
    static var storyboardID: String? { return "MoviesViewController" }
}
