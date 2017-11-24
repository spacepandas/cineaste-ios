//
//  MyMoviesViewController.swift
//  Cineaste
//
//  Created by Christian Braun on 02.11.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit
import CoreData

class MyMoviesViewController: UIViewController, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    @IBOutlet weak fileprivate var movieTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak fileprivate var myMoviesTableView: UITableView!

    var fetchedResultsController: NSFetchedResultsController<StoredMovie>?
    let wantToSeeMoviesPredicate = NSPredicate(format: "watched == %@", NSNumber(value: false))
    let seenMoviesPredicate = NSPredicate(format: "watched == %@", NSNumber(value: true))

    override func viewDidLoad() {
        super.viewDidLoad()
        myMoviesTableView.dataSource = self
        setupFetchedResultsController()
        fetchedResultsController?.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    fileprivate func setupFetchedResultsController() {
        let request: NSFetchRequest<StoredMovie> = StoredMovie.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        request.predicate = wantToSeeMoviesPredicate
        fetchedResultsController = NSFetchedResultsController<StoredMovie>(
            fetchRequest: request,
            managedObjectContext: AppDelegate.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print(error)
            return
        }
        myMoviesTableView.reloadData()
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return fetchedResultsController?.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath)
        let obj = fetchedResultsController?.object(at: indexPath)
        cell.textLabel?.text = obj?.title
        return cell
    }

    // MARK: - NSFetchedResultsControllerDelegate

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        myMoviesTableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert {
            guard let indexPath = newIndexPath else { return }
            myMoviesTableView.insertRows(at: [indexPath], with: .fade)
        } else if type == .delete {
            guard let indexPath = indexPath else { return }
            myMoviesTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        myMoviesTableView.endUpdates()
    }

    // MARK: - Actions

    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            fetchedResultsController?.fetchRequest.predicate = wantToSeeMoviesPredicate
        case 1:
            fetchedResultsController?.fetchRequest.predicate = seenMoviesPredicate
        default:
            break
        }
        DispatchQueue.main.async {
            try? self.fetchedResultsController?.performFetch()
            self.myMoviesTableView.reloadData()
        }
    }
}
