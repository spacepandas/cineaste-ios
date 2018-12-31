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
        try persistentStoreCoordinator
            .addPersistentStore(ofType: NSInMemoryStoreType,
                                configurationName: nil,
                                at: nil,
                                options: nil)
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
        container.loadPersistentStores { description, error in
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
                             voteAverage: Double,
                             voteCount: Double,
                             watched: Bool,
                             watchedDate: Date?,
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
            object.setValue(voteCount, forKey: "voteCount")
            object.setValue(watched, forKey: "watched")
            object.setValue(watchedDate, forKey: "watchedDate")
            object.setValue(listPosition, forKey: "listPosition")
        }

        //add 2 movies
        insertMovieItem(id: 351_286,
                        // swiftlint:disable:next line_length
                        overview: "Nach den Ereignissen in dem Themenpark Jurassic World auf der Insel Isla Nublar können die Dinosaurier seit vier Jahren frei leben, bis ein Vulkanausbruch ihre Existenz bedroht. Die frühere Parkmanagerin Claire Dearing hat nun die Dinosaur Protection Group (DPG) gegründet – eine Organisation zum Schutz der Dinosaurier. Sie engagiert Owen Grady, einen ehemaligen Dinosaurier-Trainer, welcher beim Park gearbeitet hatte, um ihr zu helfen, die restlich verbliebenen Dinosaurier von der Insel zu retten. Owen will außerdem Blue ausfindig machen, die letzte Überlebende der vier Raptoren, die er einst trainiert und großgezogen hatte. Außerdem bricht ein neu geschaffener Gen-Hybrid namens Indoraptor aus.",
                        poster: nil,
                        posterPath: "/oA2QCC7hIhMRP0TdY91xFNqyVCj.jpg",
                        releaseDate: "Jun 06, 2018 02:00:00".dateFromImportedMoviesString!,
                        runtime: 128,
                        title: "Jurassic World: Das gefallene Königreich",
                        voteAverage: 6.5,
                        voteCount: 3_108,
                        watched: true,
                        watchedDate: "Sep 10, 2018 00:09:46".dateFromImportedMoviesString!,
                        listPosition: 0)

        insertMovieItem(id: 674,
                        // swiftlint:disable:next line_length
                        overview: "Das große Abenteuer beginnt, als der Feuerkelch Harry Potters Namen freigibt und Harry damit Teilnehmer eines gefährlichen Wettbewerbs unter drei ruhmreichen Zauberschulen wird – des Trimagischen Turniers. Wer aber könnte Harrys Namen in den Feuerkelch geworfen haben? Jetzt muss er einen gefährlichen Drachen bezwingen, mit gespenstischen Wasserdämonen kämpfen und einem verzauberten Labyrinth entkommen – nur, um am Ende Dem-dessen-Name-nicht-genannt-werden-darf gegenüberzustehen.",
                        poster: nil,
                        posterPath: "/4B1roGv0hprkxn72kX7wWzvYh0w.jpg",
                        releaseDate: "Nov 16, 2005 00:00:00".dateFromImportedMoviesString!,
                        runtime: 157,
                        title: "Harry Potter und der Feuerkelch",
                        voteAverage: 7.599_999_999_999_999_6,
                        voteCount: 8_077,
                        watched: true,
                        watchedDate: "Jul 03, 2018 07:18:47".dateFromImportedMoviesString!,
                        listPosition: 0)

        do {
            try mockPersistantContainer.viewContext.save()
        } catch {
            print("create fakes error \(error)")
        }
    }

    func flushData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> =
            NSFetchRequest<NSFetchRequestResult>(entityName: "StoredMovie")
        let objs = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            mockPersistantContainer.viewContext.delete(obj)
        }
        try! mockPersistantContainer.viewContext.save()
    }
}
