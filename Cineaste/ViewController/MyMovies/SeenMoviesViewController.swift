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
    @IBOutlet weak fileprivate var myMoviesTableView: UITableView!
    var fetchedResultsManager = FetchedResultsManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        myMoviesTableView.dataSource = self
        title = NSLocalizedString("Seen", comment: "Title for seen view controller")

        fetchedResultsManager.delegate = self
        fetchedResultsManager.setup(with: seenMoviesPredicate) {
            myMoviesTableView.reloadData()
        }
    }
}

extension SeenMoviesViewController: MoviesViewControllerDelegate {
    func beginUpdate() {
        myMoviesTableView.beginUpdates()
    }
    func insertRows(at index: [IndexPath]) {
        myMoviesTableView.insertRows(at: index, with: .fade)
    }
    func deleteRows(at index: [IndexPath]) {
        myMoviesTableView.deleteRows(at: index, with: .fade)
    }
    func endUpdate() {
        myMoviesTableView.endUpdates()
    }
}

extension SeenMoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsManager.controller?.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SeenListCell", for: indexPath) as? SeenListCell
            else { fatalError("cell could not be dequeued") }
        guard let movie = fetchedResultsManager.controller?.object(at: indexPath)
            else { fatalError("no data for cell found") }

        cell.configure(with: movie)

        return cell
    }
}
