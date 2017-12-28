//
//  SeenMoviesViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 05.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit
import CoreData

class SeenMoviesViewController: UIViewController {
    @IBOutlet var myMoviesTableView: UITableView! {
        didSet {
            myMoviesTableView.dataSource = dataSource
            myMoviesTableView.delegate = self
            myMoviesTableView.estimatedRowHeight = 120
            myMoviesTableView.rowHeight = UITableViewAutomaticDimension
            myMoviesTableView.tableFooterView = UIView()
            myMoviesTableView.backgroundColor = UIColor.basicBackground
        }
    }

    var fetchedResultsManager = FetchedResultsManager()
    private let dataSource = SeenMoviesSource()
    private var selectedMovie: StoredMovie?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Seen", comment: "Title for seen view controller")

        fetchedResultsManager.delegate = self
        fetchedResultsManager.setup(with: seenMoviesPredicate) {
            update(dataSource)
            myMoviesTableView.reloadData()
        }
    }

    func update(_ dataSource: SeenMoviesSource) {
        if let objects = fetchedResultsManager.controller?.fetchedObjects {
            dataSource.fetchedObjects = objects
        }
    }
}

extension SeenMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedMovie = dataSource.fetchedObjects[indexPath.row]

        let movieDetailVC = MovieDetailViewController.instantiate()
        movieDetailVC.storedMovie = selectedMovie
        self.navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}

extension SeenMoviesViewController: FetchedResultsManagerDelegate {
    func beginUpdate() {
        myMoviesTableView.beginUpdates()
    }
    func insertRows(at index: [IndexPath]) {
        update(dataSource)
        myMoviesTableView.insertRows(at: index, with: .fade)
    }
    func deleteRows(at index: [IndexPath]) {
        update(dataSource)
        myMoviesTableView.deleteRows(at: index, with: .fade)
    }
    func endUpdate() {
        myMoviesTableView.endUpdates()
    }
}

extension SeenMoviesViewController: Instantiable {
    static var storyboard: Storyboard { return .main }
    static var storyboardID: String? { return "SeenMoviesViewController" }
}
