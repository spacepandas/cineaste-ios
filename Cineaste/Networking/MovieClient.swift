//
//  MovieClient.swift
//  Cineaste
//
//  Created by Christian Braun on 20.10.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

class MovieClient: NSObject {
    static let baseUrl = "https://api.themoviedb.org/3/"
    fileprivate static let apiKey = ApiKeyStore.theMovieDbKey()
    static var staticQuery:String {
        get {
            return "?query={QUERY}&language=de&api_key=\(apiKey)"
        }
    }
    
    func search(query: String, completion: ([Movie]?, Error) ->()) {
        var urlAsString = "\(MovieClient.baseUrl)/search/movie\(MovieClient.staticQuery)"
        guard let url = URL(string:urlAsString) else {
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler:{ data, response, error in
            
        })
    }
}
