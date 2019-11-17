//
//  CoreDataMigratorTests.swift
//  CineasteTests
//
//  Created by Xaver Lohmüller on 17.04.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import XCTest
import CoreData
@testable import Cineaste_App

@available(*, deprecated)
class CoreDataMigratorTests: XCTestCase {

    func testCoreDataMigratorShouldLoadMoviesFromCoreData() throws {
        // Given
        let container = NSPersistentContainer.testContainer
        [
            StoredMovie(context: container.viewContext),
            StoredMovie(context: container.viewContext),
            StoredMovie(context: container.viewContext),
            StoredMovie(context: container.viewContext)
        ]
            .enumerated()
            .map { $0.element.id = Int64($0.offset); return $0.element }
            .forEach(container.viewContext.insert)

        // When
        let movies = CoreDataMigrator(container: container).coreDataMovies

        // Then
        XCTAssertEqual(movies.count, 4)
    }

    func testCoreDataMigratorShouldRemoveMoviesFromCoreData() throws {
        // Given
        let container = NSPersistentContainer.testContainer
        [
            StoredMovie(context: container.viewContext),
            StoredMovie(context: container.viewContext),
            StoredMovie(context: container.viewContext),
            StoredMovie(context: container.viewContext)
        ]
            .enumerated()
            .map { $0.element.id = Int64($0.offset); return $0.element }
            .forEach(container.viewContext.insert)
        XCTAssertFalse(container.persistentStoreCoordinator.persistentStores.isEmpty)

        // When
        try CoreDataMigrator(container: container).clearCoreData()

        // Then
        let fetchRequest: NSFetchRequest<StoredMovie> = StoredMovie.fetchRequest()
        XCTAssertThrowsError(try fetchRequest.execute())
        XCTAssert(container.persistentStoreCoordinator.persistentStores.isEmpty)
    }
}

private extension NSPersistentContainer {
    static var testContainer: NSPersistentContainer {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, _ in }

        return container
    }
}
