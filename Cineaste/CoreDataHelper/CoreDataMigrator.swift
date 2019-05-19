//
//  CoreDataMigrator.swift
//  Cineaste App
//
//  Created by Xaver Lohmüller on 16.04.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import CoreData
import UIKit

struct CoreDataMigrator {
    private let container: NSPersistentContainer

    init(container: NSPersistentContainer = .migrationContainer) {
        self.container = container
    }

    var coreDataMovies: Set<Movie> {
        assert(Thread.isMainThread,
               "Must be called on main thread because of core data view context")

        let request: NSFetchRequest<StoredMovie> = StoredMovie.fetchRequest()
        let results = try? container.viewContext.fetch(request)
        return Set(results?.map(Movie.init) ?? [])
    }

    func clearCoreData() throws {
        let coordinator = container.persistentStoreCoordinator
        for store in coordinator.persistentStores {
            try coordinator.remove(store)
            let fileManager = FileManager.default
            if let url = store.url,
                fileManager.isDeletableFile(atPath: url.path) {
                try fileManager.removeItem(at: url)
            }
        }
    }
}

private extension NSPersistentContainer {
    static let migrationContainer: NSPersistentContainer = {
        $0.loadPersistentStores { _, _ in }
        return $0
    }(NSPersistentContainer(name: "Model"))
}

private extension Movie {
    init(storedMovie: StoredMovie) {
        self.init(
            id: storedMovie.id,
            title: storedMovie.title ?? "",
            voteAverage: storedMovie.voteAverage,
            voteCount: storedMovie.voteCount,
            posterPath: storedMovie.posterPath,
            overview: storedMovie.overview ?? "",
            runtime: storedMovie.runtime,
            releaseDate: storedMovie.releaseDate,
            poster: UIImage(data: storedMovie.poster ?? Data()),
            watched: storedMovie.watched,
            watchedDate: storedMovie.watchedDate,
            listPosition: Int(storedMovie.listPosition),
            popularity: 0
        )
    }
}
