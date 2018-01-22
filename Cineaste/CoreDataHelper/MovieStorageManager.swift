//
//  MovieStorageManager.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 28.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit
import CoreData

// swiftlint:disable implicitly_unwrapped_optional

class MovieStorageManager {
    let persistentContainer: NSPersistentContainer!

    // MARK: Init with dependency
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }

    convenience init() {
        //Use the default container for production environment
        self.init(container: AppDelegate.persistentContainer)
    }

    lazy var backgroundContext: NSManagedObjectContext = {
        let context = self.persistentContainer.newBackgroundContext()
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()

    // MARK: CRUD
    func insertMovieItem(id: Int64,
                         overview: String,
                         poster: Data?,
                         posterPath: String,
                         releaseDate: Date,
                         runtime: Int16,
                         title: String,
                         voteAverage: Float,
                         watched: Bool) {
        let storedMovie = StoredMovie(context: backgroundContext)
//        guard let storedMovie = NSEntityDescription
//            .insertNewObject(forEntityName: "StoredMovie",
//                             into: backgroundContext) as? StoredMovie else { return }
        storedMovie.id = id
        storedMovie.title = title
        storedMovie.overview = overview

        storedMovie.posterPath = posterPath
        storedMovie.poster = poster

        storedMovie.releaseDate = releaseDate
        storedMovie.runtime = runtime
        storedMovie.voteAverage = voteAverage

        storedMovie.watched = watched
    }

    func insertMovieItem(with movie: Movie,
                         watched: Bool) {
        let storedMovie = StoredMovie(context: backgroundContext)
//        guard let storedMovie = NSEntityDescription
//            .insertNewObject(forEntityName: "StoredMovie",
//                             into: backgroundContext) as? StoredMovie else { return }
        storedMovie.id = movie.id
        storedMovie.title = movie.title
        storedMovie.overview = movie.overview

        storedMovie.posterPath = movie.posterPath
        if let moviePoster = movie.poster {
            storedMovie.poster = UIImageJPEGRepresentation(moviePoster, 1)
        }

        storedMovie.releaseDate = movie.releaseDate
        storedMovie.runtime = movie.runtime
        storedMovie.voteAverage = movie.voteAverage

        storedMovie.watched = watched
    }

    func updateMovieItem(movie: StoredMovie,
                         watched: Bool) {
//        let storedMovie = StoredMovie(context: backgroundContext)
        guard let storedMovie = NSEntityDescription
            .insertNewObject(forEntityName: "StoredMovie",
                             into: backgroundContext) as? StoredMovie else { return }
        storedMovie.id = movie.id
        storedMovie.title = movie.title
        storedMovie.overview = movie.overview

        storedMovie.posterPath = movie.posterPath
        storedMovie.poster = movie.poster

        storedMovie.releaseDate = movie.releaseDate
        storedMovie.runtime = movie.runtime
        storedMovie.voteAverage = movie.voteAverage

        storedMovie.watched = watched
    }

    func fetchAll() -> [StoredMovie] {
        let request: NSFetchRequest<StoredMovie> = StoredMovie.fetchRequest()
        let results = try? persistentContainer.viewContext.fetch(request)
        return results ?? [StoredMovie]()
    }

    func remove(_ storedMovie: StoredMovie) {
        let object = backgroundContext.object(with: storedMovie.objectID)
        backgroundContext.delete(object)
    }

    func save(handler: ((_ success: Bool, _ error: Error?) -> Void)? = nil) {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
                handler?(true, nil)
            } catch {
                print("Save error \(error)")
                handler?(false, error)
            }
        }
    }
}
