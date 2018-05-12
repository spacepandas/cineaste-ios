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
    var controller: NSFetchedResultsController<StoredMovie>?
    weak var delegate: FetchedResultsManagerDelegate?

    private var loadMoviesForExport = false
    var exportMoviesPath: URL?

    func setup(with predicate: NSPredicate?,
               context: NSManagedObjectContext = AppDelegate.viewContext,
               completionHandler handler: (() -> Void)? = nil) {
        let request: NSFetchRequest<StoredMovie> = StoredMovie.fetchRequest()
        request.predicate = predicate
        sort(fetchRequest: request, for: predicate)

        controller = NSFetchedResultsController<StoredMovie>(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        do {
            try controller?.performFetch()
        } catch {
            print(error)
            return
        }
        controller?.delegate = self
        handler?()
    }

    private func sort(fetchRequest: NSFetchRequest<StoredMovie>?, for predicate: NSPredicate?) {
        if predicate == MovieListCategory.seen.predicate {
            fetchRequest?.sortDescriptors = [NSSortDescriptor(key: "watchedDate", ascending: false)]
        } else if predicate == MovieListCategory.wantToSee.predicate {
            fetchRequest?.sortDescriptors = [NSSortDescriptor(key: "listPosition", ascending: true),
                                            NSSortDescriptor(key: "title", ascending: true)]
        }
    }

    func refetch(for predicate: NSPredicate?, completionHandler handler: (() -> Void)? = nil) {
        controller?.fetchRequest.predicate = predicate
        sort(fetchRequest: controller?.fetchRequest, for: predicate)

        do {
            try controller?.performFetch()
        } catch {
            print(error)
            return
        }
        handler?()
    }
}

extension FetchedResultsManager {
    func exportMoviesList(completionHandler: @escaping (Result<Any?>) -> Void) {
        loadMoviesForExport = true

        refetch(for: nil) {
            guard let movies = self.controller?.fetchedObjects,
                !movies.isEmpty
                else {
                    completionHandler(Result.error(FileExportError.noCoreDataObjectsFound))
                    return
            }

            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted

            let export = ImportExportObject(with: movies)

            guard let data = try? encoder.encode(export) else {
                completionHandler(Result.error(FileExportError.serializingCoreDataObjects))
                return
            }

            self.saveToDocumentsDirectory(data) { result in
                switch result {
                case .success:
                    print("Export in file was successful :: data = \(String(data: data, encoding: .utf8) ?? "")")
                    completionHandler(Result.success(nil))
                case .error(let error):
                    print(error)
                    self.exportMoviesPath = nil
                    completionHandler(Result.error(FileExportError.writingContentInFile))
                }

                self.loadMoviesForExport = false
            }
        }
    }

    func importData(_ data: Data, completionHandler: @escaping ((Result<Int>) -> Void)) {
        let storageManager = MovieStorage()

        storageManager.resetCoreData { _ in
            let decoder = JSONDecoder()
            decoder.userInfo[.context] = storageManager.backgroundContext

            do {
                let export = try decoder.decode(ImportExportObject.self, from: data)
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
                            completionHandler(Result.success(movies.count))
                        } catch {
                            completionHandler(Result.error(FileImportError.savingNewMovies))
                        }
                    }
                }
            } catch {
                completionHandler(Result.error(FileImportError.parsingJsonToStoredMovie))
            }
        }
    }

    private func saveToDocumentsDirectory(_ data: Data, completionHandler: (Result<Bool>) -> Void) {
        guard let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first,
            let documentsDirectoryPath = URL(string: "file://\(documentsDirectoryPathString)")
            else {
                completionHandler(Result.error(FileExportError.creatingDocumentPath))
                return
        }

        let jsonFilePath = documentsDirectoryPath.appendingPathComponent(Strings.exportMoviesFileName)
        exportMoviesPath = jsonFilePath

        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false

        // creating a .json file in the Documents folder
        if !fileManager.fileExists(atPath: jsonFilePath.path, isDirectory: &isDirectory) {
            let created = fileManager.createFile(atPath: jsonFilePath.path, contents: nil, attributes: nil)
            guard created == true else {
                completionHandler(Result.error(FileExportError.creatingFileAtPath))
                return
            }
        }

        // Write that JSON to the file created earlier
        do {
            let file = try FileHandle(forWritingTo: jsonFilePath)
            file.truncateFile(atOffset: 0)
            file.write(data)
            completionHandler(Result.success(true))
        } catch {
            completionHandler(Result.error(FileExportError.writingContentInFile))
        }
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
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            delegate?.moveRow(at: indexPath, to: newIndexPath)
            return
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard loadMoviesForExport == false else { return }

        delegate?.endUpdate()
    }
}
