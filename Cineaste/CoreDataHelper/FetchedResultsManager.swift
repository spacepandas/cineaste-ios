//
//  FetchedResultsManager.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 05.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import CoreData

final class FetchedResultsManager: NSObject {
    let controller: NSFetchedResultsController<StoredMovie>
    weak var delegate: FetchedResultsManagerDelegate?

    var movies: [StoredMovie] {
        return controller.fetchedObjects ?? []
    }

    init(with predicate: NSPredicate? = nil,
         context: NSManagedObjectContext = AppDelegate.viewContext) {

        let request: NSFetchRequest<StoredMovie> = StoredMovie.fetchRequest()
        request.predicate = predicate

        if predicate == MovieListCategory.seen.predicate {
            request.sortDescriptors = [
                NSSortDescriptor(key: "watchedDate", ascending: false)
            ]
        } else {
            request.sortDescriptors = [
                NSSortDescriptor(key: "listPosition", ascending: true),
                NSSortDescriptor(key: "title", ascending: true)
            ]
        }

        controller = NSFetchedResultsController<StoredMovie>(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)

        super.init()

        controller.delegate = self
        try? controller.performFetch()
    }

    func refetch(for predicate: NSPredicate? = nil) {
        controller.fetchRequest.predicate = predicate

        if predicate == MovieListCategory.seen.predicate {
            controller.fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "watchedDate", ascending: false)
            ]
        } else {
            controller.fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "listPosition", ascending: true),
                NSSortDescriptor(key: "title", ascending: true)
            ]
        }

        try? controller.performFetch()
    }
}

extension FetchedResultsManager: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.beginUpdate()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { return }
            delegate?.insertRows(at: [indexPath])
        case .delete:
            guard let indexPath = indexPath else { return }
            delegate?.deleteRows(at: [indexPath])
        case .update:
            guard let indexPath = newIndexPath else { return }
            delegate?.updateRows(at: [indexPath])
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath
                else { return }
            delegate?.moveRow(at: indexPath, to: newIndexPath)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.endUpdate()
    }
}
