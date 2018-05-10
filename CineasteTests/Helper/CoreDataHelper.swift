//
//  CoreDataHelper.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import CoreData

//see tutorial:
//https://www.andrewcbancroft.com/2015/01/13/unit-testing-model-layer-core-data-swift/

func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
    let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!

    let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)

    do {
        try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
    } catch {
        print("Adding in-memory persistent store failed")
    }

    let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator

    return managedObjectContext
}

class CoreDataHelper {
    var mockPersistantContainer: NSPersistentContainer = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        let container = NSPersistentContainer(name: "PersistentStoredMovies", managedObjectModel: managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false // Make it simpler in test env

        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition(description.type == NSInMemoryStoreType)

            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()

    //Convenient method for getting the number of data in store now
    func numberOfItemsInPersistentStore() -> Int {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "StoredMovie")
        let results = try! mockPersistantContainer.viewContext.fetch(request)
        return results.count
    }

    func initStubs() {
        func insertMovieItem(id: Int64,
                             overview: String,
                             poster: Data?,
                             posterPath: String,
                             releaseDate: Date,
                             runtime: Int16,
                             title: String,
                             voteAverage: Float,
                             watched: Bool,
                             watchedDate: Date,
                             listPosition: Int16) {
            let object = NSEntityDescription.insertNewObject(forEntityName: "StoredMovie",
                                                             into: mockPersistantContainer.viewContext)
            object.setValue(id, forKey: "id")
            object.setValue(overview, forKey: "overview")
            object.setValue(poster, forKey: "poster")
            object.setValue(posterPath, forKey: "posterPath")
            object.setValue(releaseDate, forKey: "releaseDate")
            object.setValue(runtime, forKey: "runtime")
            object.setValue(title, forKey: "title")
            object.setValue(voteAverage, forKey: "voteAverage")
            object.setValue(watched, forKey: "watched")
            object.setValue(watchedDate, forKey: "watchedDate")
            object.setValue(listPosition, forKey: "listPosition")
        }

        //add 4 movies
        insertMovieItem(id: 1, overview: "", poster: nil, posterPath: "", releaseDate: Date(), runtime: 1, title: "", voteAverage: 2, watched: true, watchedDate: Date(), listPosition: 0)
        insertMovieItem(id: 2, overview: "", poster: nil, posterPath: "", releaseDate: Date(), runtime: 1, title: "", voteAverage: 2, watched: true, watchedDate: Date(), listPosition: 0)
        insertMovieItem(id: 3, overview: "", poster: nil, posterPath: "", releaseDate: Date(), runtime: 1, title: "", voteAverage: 2, watched: true, watchedDate: Date(), listPosition: 0)
        insertMovieItem(id: 4, overview: "", poster: nil, posterPath: "", releaseDate: Date(), runtime: 1, title: "", voteAverage: 2, watched: true, watchedDate: Date(), listPosition: 0)

        do {
            try mockPersistantContainer.viewContext.save()
        }  catch {
            print("create fakes error \(error)")
        }
    }

    func flushData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "StoredMovie")
        let objs = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            mockPersistantContainer.viewContext.delete(obj)
        }
        try! mockPersistantContainer.viewContext.save()
    }
}
