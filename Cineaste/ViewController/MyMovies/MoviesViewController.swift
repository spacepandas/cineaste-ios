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
                NSLocalizedString("Du hast keine Filme auf deiner \"\(category.title)\"-Liste.\nFüge doch einen neuen Titel hinzu.",
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

            myMoviesTableView.rowHeight = UITableViewAutomaticDimension
            myMoviesTableView.estimatedRowHeight = 80
        }
    }

    let fetchedResultsManager = FetchedResultsManager()
    let storageManager = MovieStorage()
    var selectedMovie: StoredMovie?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.basicBackground

        fetchedResultsManager.delegate = self
        fetchedResultsManager.setup(with: category.predicate) {
            myMoviesTableView.reloadData()
            hideTableViewIfEmpty()
        }
    }

    @IBAction func triggerSearchMovieAction(_ sender: UIBarButtonItem) {
        perform(segue: .showSearchFromMovieList, sender: self)
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch Segue(initWith: segue) {
        case .showSearchFromMovieList?:
            let navigationVC = segue.destination as? UINavigationController
            let vc = navigationVC?.viewControllers.first as? SearchMoviesViewController
            vc?.storageManager = storageManager
        case .showMovieDetail?:
            let vc = segue.destination as? MovieDetailViewController
            vc?.storedMovie = selectedMovie
            vc?.storageManager = storageManager
            vc?.type = (category == MovieListCategory.seen) ? .seen : .wantToSee
        default:
            break
        }
    }
}

// MARK: - UITableViewDataSource

extension MoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsManager.controller?.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieListCell.identifier, for: indexPath) as? MovieListCell
            else {
                fatalError("Unable to dequeue cell for identifier: \(MovieListCell.identifier)")
        }

        if let controller = fetchedResultsManager.controller {
            cell.configure(with: controller.object(at: indexPath))
        }

        return cell
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

        perform(segue: .showMovieDetail, sender: nil)
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
