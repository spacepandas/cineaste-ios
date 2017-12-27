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
            myMoviesTableView.tableFooterView = UIView()
            myMoviesTableView.backgroundColor = UIColor.basicBackground
        }
    }

    var fetchedResultsManager = FetchedResultsManager()
    private let dataSource = WantToSeeMoviesSource()

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
