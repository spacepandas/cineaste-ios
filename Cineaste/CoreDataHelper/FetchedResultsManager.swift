//
//  FetchedResultsManager.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 05.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import CoreData

enum FileExportError: Error {
    case noCoreDataObjectsFound
    case creatingDocumentPath
    case creatingFileAtPath
    case writingContentInFile
    case serializingCoreDataObjects
}

enum FileImportError: Error {
    case parsingJsonToStoredMovie
    case savingNewMovies
}

final class FetchedResultsManager: NSObject {
    let controller: NSFetchedResultsController<StoredMovie>
    weak var delegate: FetchedResultsManagerDelegate?

    private var loadMoviesForExport = false
    var exportMoviesPath: String?

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

extension FetchedResultsManager {
    func exportMoviesList() throws {
        loadMoviesForExport = true

        refetch()

        guard !movies.isEmpty else {
            throw(FileExportError.noCoreDataObjectsFound)
        }

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        let data = try encoder.encode(ImportExportObject(with: movies))
        try saveToDocumentsDirectory(data)
        loadMoviesForExport = false
    }

    func importData(_ data: Data, completionHandler: @escaping ((Result<Int>) -> Void)) {
        let storageManager = MovieStorage()

        storageManager.resetCoreData { _ in
            let decoder = JSONDecoder()
            decoder.userInfo[.context] = storageManager.backgroundContext

            do {
                let export = try decoder.decode(ImportExportObject.self,
                                                from: data)
                let movies = export.movies

                let dispatchGroup = DispatchGroup()

                //load all posters
                for movie in movies {
                    dispatchGroup.enter()

                    movie.loadPoster { poster in
                        movie.poster = poster

                        dispatchGroup.leave()
                    }
                }

                dispatchGroup.notify(queue: .global()) {
                    if storageManager.backgroundContext.hasChanges {
                        do {
                            try storageManager.backgroundContext.save()
                            completionHandler(.success(movies.count))
                        } catch {
                            completionHandler(.error(FileImportError.savingNewMovies))
                        }
                    }
                }
            } catch {
                completionHandler(.error(FileImportError.parsingJsonToStoredMovie))
            }
        }
    }

    private func saveToDocumentsDirectory(_ data: Data) throws {
        let documentsDirectory =
            NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                .userDomainMask,
                                                true)[0]

        let moviesPath = documentsDirectory + String.exportMoviesFileName(with: Date().formatted)
        exportMoviesPath = moviesPath

        let fileManager = FileManager.default

        // creating a .json file in the Documents folder
        if !fileManager.fileExists(atPath: moviesPath) {
            guard fileManager.createFile(atPath: moviesPath,
                                         contents: nil,
                                         attributes: nil)
                else {
                    throw(FileExportError.creatingFileAtPath)
            }
        }

        // Write that JSON to the file created earlier
        guard let file = FileHandle(forWritingAtPath: moviesPath) else {
            throw(FileExportError.writingContentInFile)
        }
        file.truncateFile(atOffset: 0)
        file.write(data)
    }
}

extension FetchedResultsManager: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard loadMoviesForExport == false else { return }

        delegate?.beginUpdate()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard loadMoviesForExport == false else { return }

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
        guard loadMoviesForExport == false else { return }

        delegate?.endUpdate()
    }
}
