//
//  WantToSeeMoviesViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 05.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit
import CoreData

class WantToSeeMoviesViewController: UIViewController {
    @IBOutlet var myMoviesTableView: UITableView! {
        didSet {
            myMoviesTableView.dataSource = dataSource
            myMoviesTableView.delegate = self
            myMoviesTableView.tableFooterView = UIView()
            myMoviesTableView.backgroundColor = UIColor.basicBackground
        }
    }

    var fetchedResultsManager = FetchedResultsManager()
    private let dataSource = WantToSeeMoviesSource()
    private var selectedMovie: StoredMovie?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Want to see", comment: "Title for want to see view controller")

        fetchedResultsManager.delegate = self
        fetchedResultsManager.setup(with: wantToSeeMoviesPredicate) {
            update(dataSource)
            myMoviesTableView.reloadData()
        }
    }

    func update(_ dataSource: WantToSeeMoviesSource) {
        if let objects = fetchedResultsManager.controller?.fetchedObjects {
            dataSource.fetchedObjects = objects
        }
    }
}

extension WantToSeeMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedMovie = dataSource.fetchedObjects[indexPath.row]

        let movieDetailVC = MovieDetailViewController.instantiate()
        movieDetailVC.storedMovie = selectedMovie
        self.navigationController?.pushViewController(movieDetailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dataSource.fetchedObjects.isEmpty {
            return tableView.frame.size.height
        } else {
            return UITableViewAutomaticDimension
        }
    }
}

extension WantToSeeMoviesViewController: FetchedResultsManagerDelegate {
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

extension WantToSeeMoviesViewController: Instantiable {
    static var storyboard: Storyboard { return .main }
    static var storyboardID: String? { return "WantToSeeMoviesViewController" }
}
