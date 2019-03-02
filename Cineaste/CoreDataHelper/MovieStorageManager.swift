//
//  MovieStorageManager.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 28.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit
import CoreData

class MovieStorageManager {
    let persistentContainer: NSPersistentContainer

    // MARK: Init with dependency
    init(container: NSPersistentContainer = AppDelegate.persistentContainer) {
        persistentContainer = container
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }

    lazy var backgroundContext: NSManagedObjectContext = {
        let context = self.persistentContainer.newBackgroundContext()
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()

    // MARK: CRUD
    //swiftlint:disable:next function_parameter_count
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
                         completion: ((_ result: Result<Bool>) -> Void)? = nil) {
        backgroundContext.perform {
            let storedMovie = StoredMovie(context: self.backgroundContext)
            storedMovie.id = id
            storedMovie.title = title
            storedMovie.overview = overview

            storedMovie.posterPath = posterPath
            storedMovie.poster = poster

            storedMovie.releaseDate = releaseDate
            storedMovie.runtime = runtime
            storedMovie.voteAverage = voteAverage
            storedMovie.voteCount = voteCount

            storedMovie.watched = watched
            storedMovie.watchedDate = watched ? Date() : nil

            self.backgroundContext.saveOrRollback(completion: completion)
        }
    }

    func insertMovieItem(with movie: Movie,
                         watched: Bool,
                         completion: ((_ result: Result<Bool>) -> Void)? = nil) {
        backgroundContext.perform {
            let storedMovie = StoredMovie(context: self.backgroundContext)
            storedMovie.id = movie.id
            storedMovie.title = movie.title
            storedMovie.overview = movie.overview

            storedMovie.posterPath = movie.posterPath
            if let moviePoster = movie.poster {
                storedMovie.poster = moviePoster.jpegData(compressionQuality: 1)
            }

            storedMovie.releaseDate = movie.releaseDate
            storedMovie.runtime = movie.runtime
            storedMovie.voteAverage = movie.voteAverage
            storedMovie.voteCount = movie.voteCount

            storedMovie.watched = watched
            storedMovie.watchedDate = watched ? Date() : nil

            self.backgroundContext.saveOrRollback(completion: completion)
        }
    }

    func updateMovieItem(with objectID: NSManagedObjectID,
                         watched: Bool,
                         completion: ((_ result: Result<Bool>) -> Void)? = nil) {
        backgroundContext.perform {
            guard let storedMovie = self.backgroundContext.object(with: objectID) as? StoredMovie else {
                fatalError("Object could not be casted to StoredMovie")
            }

            if storedMovie.watched != watched {
                storedMovie.watched = watched
            }
            if storedMovie.watchedDate != (watched ? storedMovie.watchedDate ?? Date() : nil) {
                storedMovie.watchedDate = watched ? storedMovie.watchedDate ?? Date() : nil
            }

            self.backgroundContext.saveOrRollback(completion: completion)
        }
    }

    func updateMovieItems(with movies: [StoredMovie],
                          completion: ((_ result: Result<Bool>) -> Void)? = nil) {
        backgroundContext.perform {
            for movie in movies {
                guard let storedMovie = self.backgroundContext.object(with: movie.objectID) as? StoredMovie else {
                    fatalError("Object could not be casted to StoredMovie")
                }

                storedMovie.id = movie.id
                storedMovie.title = movie.title
                storedMovie.overview = movie.overview
                storedMovie.posterPath = movie.posterPath
                storedMovie.poster = movie.poster
                storedMovie.releaseDate = movie.releaseDate
                storedMovie.runtime = movie.runtime
                storedMovie.voteAverage = movie.voteAverage
                storedMovie.voteCount = movie.voteCount
                storedMovie.watched = movie.watched
                storedMovie.watchedDate = movie.watchedDate
            }

            self.backgroundContext.saveOrRollback(completion: completion)
        }
    }

    func remove(_ storedMovie: StoredMovie,
                completion: ((_ result: Result<Bool>) -> Void)? = nil) {
        backgroundContext.perform {
            let object = self.backgroundContext.object(with: storedMovie.objectID)
            self.backgroundContext.delete(object)

            self.backgroundContext.saveOrRollback(completion: completion)
        }
    }
}

extension MovieStorageManager {
    func fetchAll() -> [StoredMovie] {
        assert(Thread.isMainThread,
               "Must be called on main thread because of core data view context")

        let request: NSFetchRequest<StoredMovie> = StoredMovie.fetchRequest()
        let results = try? persistentContainer.viewContext.fetch(request)
        return results ?? []
    }

    func fetchAllWatchlistMovies() -> [StoredMovie] {
        assert(Thread.isMainThread,
               "Must be called on main thread because of core data view context")

        let request: NSFetchRequest<StoredMovie> = StoredMovie.fetchRequest()
        request.predicate = MovieListCategory.watchlist.predicate
        let results = try? persistentContainer.viewContext.fetch(request)
        return results ?? []
    }

    func fetchMovie(for id: Int64) -> StoredMovie? {
        assert(Thread.isMainThread,
               "Must be called on main thread because of core data view context")

        let request: NSFetchRequest<StoredMovie> = StoredMovie.fetchRequest()
        request.predicate = NSPredicate(format: "id == %i", id)
        let results = try? persistentContainer.viewContext.fetch(request)
        return results?.first
    }
}
