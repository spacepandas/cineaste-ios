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
        request.sortDescriptors = FetchedResultsManager
            .sortDescriptor(for: predicate)

        controller = NSFetchedResultsController<StoredMovie>(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)

        super.init()

        controller.delegate = self

        try? controller.performFetch()
    }

    func refetch(for predicate: NSPredicate) {
        controller.fetchRequest.predicate = predicate
        controller.fetchRequest.sortDescriptors = FetchedResultsManager
            .sortDescriptor(for: predicate)

        try? controller.performFetch()
    }
}

extension FetchedResultsManager: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("🔄 Begin UI Update")
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
        print("🔄 End UI Update")
        delegate?.endUpdate()
    }
}

extension FetchedResultsManager {
    private static func sortDescriptor(for predicate: NSPredicate?) -> [NSSortDescriptor] {
        var sortDescriptor: [NSSortDescriptor]

        if predicate == MovieListCategory.seen.predicate {
            sortDescriptor = [
                NSSortDescriptor(key: "watchedDate", ascending: false)
            ]
        } else {
            sortDescriptor = [
                NSSortDescriptor(key: "listPosition", ascending: true),
                NSSortDescriptor(key: "title", ascending: true)
            ]
        }
        return sortDescriptor
    }
}
