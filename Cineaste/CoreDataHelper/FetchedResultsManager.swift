//
//  FetchedResultsManager.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 05.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import CoreData

final class FetchedResultsManager: NSObject {
    var controller: NSFetchedResultsController<StoredMovie>?
    weak var delegate: FetchedResultsManagerDelegate?

    func setup(with predicate: NSPredicate, completionHandler handler: () -> Void) {
        let request: NSFetchRequest<StoredMovie> = StoredMovie.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        request.predicate = predicate
        controller = NSFetchedResultsController<StoredMovie>(
            fetchRequest: request,
            managedObjectContext: AppDelegate.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        do {
            try controller?.performFetch()
        } catch {
            print(error)
            return
        }
        controller?.delegate = self
        handler()
    }

    func update(for predicate: NSPredicate, completionHandler handler: () -> Void) {
        controller?.fetchRequest.predicate = predicate
        do {
            try controller?.performFetch()
        } catch {
            print(error)
            return
        }
        handler()
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
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            delegate?.moveRow(at: indexPath, to: newIndexPath)
            return
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.endUpdate()
    }
}
