//
//  Movie.swift
//  Cineaste
//
//  Created by Christian Braun on 18.10.17.
//  Copyright notimeforthat.org. All rights reserved.
//

import UIKit
import CoreData

class Movie: Codable {
    fileprivate(set) var id:Int64
    fileprivate(set) var title:String
    fileprivate(set) var voteAverage:Float
    fileprivate(set) var posterPath:String
    fileprivate(set) var shortDescription:String
    var poster:UIImage?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case shortDescription = "overview"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int64.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        voteAverage = try container.decode(Float.self, forKey: .voteAverage)
        posterPath = try container.decode(String.self, forKey: .posterPath)
        shortDescription = try container.decode(String.self, forKey: .shortDescription)
    }
    
    func encode(to encoder: Encoder) throws {
        fatalError("encode not implemented on \(Movie.self)")
    }
}

extension Movie {
    static fileprivate let baseUrl = "https://api.themoviedb.org/3"
    static fileprivate let posterBaseUrl = "https://image.tmdb.org/t/p/w342";
    fileprivate static let apiKey = ApiKeyStore.theMovieDbKey()
    
    static func search(withQuery query:String) -> Resource<[Movie]>? {
        guard let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            return nil
        }
        let urlAsString = "\(Movie.baseUrl)/search/movie?language=de&api_key=\(apiKey)&query=\(escapedQuery)";
        
        return Resource(url:urlAsString, method:.get){data in
            let paginatedMovies = try? JSONDecoder().decode(PagedMovieResult.self, from: data)
            return paginatedMovies?.results
        }
    }
    
    static func latestReleases() -> Resource<[Movie]>? {
        let oneMonthInPast = Date(timeIntervalSinceNow: -60 * 60 * 24 * 30)
        let oneMonthInFuture = Date(timeIntervalSinceNow: 60 * 60 * 24 * 30)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let urlAsString = "\(Movie.baseUrl)/discover/movie?primary_release_date.gte=\(dateFormatter.string(from: oneMonthInPast))&primary_release_date.lte=\(dateFormatter.string(from: oneMonthInFuture))&api_key=\(apiKey)";
        
        return Resource(url:urlAsString, method:.get){data in
            let paginatedMovies = try? JSONDecoder().decode(PagedMovieResult.self, from: data)
            return paginatedMovies?.results
        }
    }
    
    func loadPoster() -> Resource<UIImage>? {
        let urlAsString = "\(Movie.posterBaseUrl)\(posterPath)?api_key=\(Movie.apiKey)"
        return Resource(url:urlAsString, method:.get){data in
            let image = UIImage(data: data)
            return image
        }
    }
}
