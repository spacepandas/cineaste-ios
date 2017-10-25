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

    enum CodingKeys: String, CodingKey {
        case id
        case title
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int64.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
    }
    
    func encode(to encoder: Encoder) throws {
        fatalError("encode not implemented on \(Movie.self)")
    }
}

extension Movie {
    static fileprivate let baseUrl = "https://api.themoviedb.org/3"
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
}
