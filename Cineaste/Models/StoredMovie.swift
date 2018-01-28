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
        if let moviePoster = movie.poster {
            poster = UIImageJPEGRepresentation(moviePoster, 1)
        }
        voteAverage = movie.voteAverage
        runtime = movie.runtime
        releaseDate = movie.releaseDate
        watched = false
    }
}
