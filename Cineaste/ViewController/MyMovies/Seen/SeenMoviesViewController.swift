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
            myMoviesTableView.estimatedRowHeight = 120
            myMoviesTableView.rowHeight = UITableViewAutomaticDimension
            myMoviesTableView.tableFooterView = UIView()
            myMoviesTableView.backgroundColor = UIColor.basicBackground
        }
    }

    var fetchedResultsManager = FetchedResultsManager()
    private let dataSource = SeenMoviesSource()

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
