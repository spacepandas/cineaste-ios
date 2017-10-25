//
//  Webservice.swift
//  Cineaste
//
//  Created by Christian Braun on 25.10.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import Foundation

enum NetworkError:Error {
    case parseUrl
    case parseJson
}

final class Webservice {
    static func load<A>(resource:Resource<A>?, completion: @escaping (A?, Error?) -> ()) {
        guard let resource = resource else {
            completion(nil, nil)
            return
        }
        guard let url = URL(string:resource.url) else {
            completion(nil, NetworkError.parseUrl)
            return;
        }
        var request = URLRequest(url:url)
        request.httpMethod = resource.method.rawValue
        URLSession.shared.dataTask(with: request){data, response, error in
            guard error == nil, let data = data else {
                completion(nil, error)
                return
            }
            let result = resource.parseData(data)
            completion(result, nil)
        }.resume()
    }
}
