//
//  StoredMovie.swift
//  Cineaste
//
//  Created by Christian Braun on 05.11.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit
import CoreData

enum StoredMovieDecodingError: Error {
    case dateFromString
    case entityCreation
    case findContext
}

extension CodingUserInfoKey {
    //swiftlint:disable:next force_unwrapping
    static let context = CodingUserInfoKey(rawValue: "context")!
}

@objc(StoredMovie)
class StoredMovie: NSManagedObject, Codable {

    convenience init(withMovie movie: Movie, context: NSManagedObjectContext) {
        self.init(context: context)
        id = movie.id
        title = movie.title
        overview = movie.overview
        posterPath = movie.posterPath
        if let moviePoster = movie.poster {
            poster = UIImageJPEGRepresentation(moviePoster, 1)
        }
        voteAverage = movie.voteAverage as NSDecimalNumber
        voteCount = movie.voteCount
        runtime = movie.runtime
        releaseDate = movie.releaseDate
        watched = false
        watchedDate = nil
        listPosition = 0
    }

    convenience init(context moc: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        guard let entity = NSEntityDescription.entity(forEntityName: name, in: moc) else {
            fatalError("Unable to create entity description with \(name)")
        }

        self.init(entity: entity, insertInto: moc)
    }

    enum CodingKeys: String, CodingKey {
        case overview
        case listPosition
        case releaseDate = "release_date"
        case runtime
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case watched
        case watchedDate
        case id
        case posterPath = "poster_path"
        case title
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else {
            throw StoredMovieDecodingError.findContext
        }

        let name = String(describing: type(of: self))
        guard let entity = NSEntityDescription.entity(forEntityName: name, in: context) else {
            throw StoredMovieDecodingError.entityCreation
        }

        self.init(entity: entity, insertInto: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int64.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        overview = try container.decode(String.self, forKey: .overview)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)

        voteAverage = try container.decode(Decimal.self, forKey: .voteAverage) as NSDecimalNumber
        voteCount = try container.decode(Float.self, forKey: .voteCount)
        runtime = try container.decode(Int16.self, forKey: .runtime)

        let releaseDateString = try container.decode(String.self, forKey: .releaseDate)
        guard let releaseDate = releaseDateString.dateFromImportedMoviesString else {
            throw StoredMovieDecodingError.dateFromString
        }
        self.releaseDate = releaseDate

        watched = try container.decode(Bool.self, forKey: .watched)

        if let watchedDateString = try container.decodeIfPresent(String.self, forKey: .watchedDate) {
            guard let watchedDate = watchedDateString.dateFromImportedMoviesString else {
                throw StoredMovieDecodingError.dateFromString
            }
            self.watchedDate = watchedDate
        }

        listPosition = try container.decode(Int16.self, forKey: .listPosition)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(overview, forKey: .overview)
        try container.encode(listPosition, forKey: .listPosition)
        try container.encode(releaseDate?.formattedForJson, forKey: .releaseDate)
        try container.encode(runtime, forKey: .runtime)

        if let voteAverage = voteAverage as Decimal? {
            try container.encode(voteAverage, forKey: .voteAverage)
        }

        try container.encode(voteCount, forKey: .voteCount)
        try container.encode(watched, forKey: .watched)
        try container.encodeIfPresent(watchedDate?.formattedForJson, forKey: .watchedDate)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(posterPath, forKey: .posterPath)
        try container.encode(title, forKey: .title)
    }

}

extension StoredMovie {
    static fileprivate let posterBaseUrl = "https://image.tmdb.org/t/p/w342"
    static fileprivate let apiKey = ApiKeyStore.theMovieDbKey()

    fileprivate func loadPoster() -> Resource<Data>? {
        guard let posterPath = posterPath else { return nil }
        let urlAsString = "\(StoredMovie.posterBaseUrl)\(posterPath)?api_key=\(StoredMovie.apiKey)"
        return Resource(url: urlAsString, method: .get) { data in
            return data
        }
    }

    func loadPoster(completionHandler handler: @escaping (_ poster: Data?) -> Void) {
        Webservice.load(resource: self.loadPoster()) { result in
            guard case let .success(image) = result else {
                handler(nil)
                return
            }
            handler(image)
        }
    }
}

extension StoredMovie {
    var formattedVoteAverage: String {
        if self.voteCount == 0 {
            return "-.-"
        } else {
            return (self.voteAverage as Decimal?)?.formattedWithOneFractionDigit ?? "-.-"
        }
    }
}
