//
//  StoredMovie.swift
//  Cineaste
//
//  Created by Christian Braun on 05.11.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit
import CoreData

@objc(StoredMovie)
class StoredMovie: NSManagedObject {
    convenience init(withMovie movie: Movie, context: NSManagedObjectContext) {
        self.init(context: context)
        id = movie.id
        title = movie.title
        overview = movie.overview
        posterPath = movie.posterPath
        voteAverage = movie.voteAverage
        watched = false
    }

    static func get(byId id: Int64, withContext context: NSManagedObjectContext) -> StoredMovie? {
        let fetchRequest: NSFetchRequest<StoredMovie> = StoredMovie.fetchRequest()
        let idPredicate = NSPredicate(format: "id == %d", id)
        fetchRequest.predicate = idPredicate
        let results = try? context.fetch(fetchRequest)
        return results?.first
    }

    static func insertOrUpdate(_ movie: Movie,
                               watched: Bool,
                               withContext context: NSManagedObjectContext) {
        context.mergePolicy = NSOverwriteMergePolicy
        let storedMovie = StoredMovie(withMovie: movie, context: context)
        storedMovie.watched = watched
        try? context.save()
    }
}
