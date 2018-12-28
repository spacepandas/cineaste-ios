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
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
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
            self.save(completion: completion)
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
            self.save(completion: completion)
        }
    }

    func updateMovieItem(with movie: StoredMovie,
                         watched: Bool,
                         completion: ((_ result: Result<Bool>) -> Void)? = nil) {
        backgroundContext.perform {
            let storedMovie = StoredMovie(context: self.backgroundContext)
            storedMovie.id = movie.id
            storedMovie.title = movie.title
            storedMovie.overview = movie.overview

            storedMovie.posterPath = movie.posterPath
            storedMovie.poster = movie.poster

            storedMovie.releaseDate = movie.releaseDate
            storedMovie.runtime = movie.runtime
            storedMovie.voteAverage = movie.voteAverage
            storedMovie.voteCount = movie.voteCount

            storedMovie.watched = watched
            storedMovie.watchedDate = watched ? Date() : nil
            self.save(completion: completion)
        }
    }

    func updateMovieItems(with movies: [StoredMovie],
                          completion: ((_ result: Result<Bool>) -> Void)? = nil) {
        backgroundContext.perform {
            for movie in movies {
                let storedMovie = StoredMovie(context: self.backgroundContext)
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
            self.save(completion: completion)
        }
    }

    func remove(_ storedMovie: StoredMovie,
                completion: ((_ result: Result<Bool>) -> Void)? = nil) {
        backgroundContext.perform {
            let object = self.backgroundContext.object(with: storedMovie.objectID)
            self.backgroundContext.delete(object)
            self.save(completion: completion)
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
}

extension MovieStorageManager {
    private func save(completion: ((_ result: Result<Bool>) -> Void)? = nil) {
        guard backgroundContext.hasChanges else { return }

        do {
            try backgroundContext.save()
            completion?(Result.success(true))
        } catch {
            print("Save error \(error)")
            completion?(Result.error(error))
        }
    }
}
