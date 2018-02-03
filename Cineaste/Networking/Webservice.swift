//
//  Webservice.swift
//  Cineaste
//
//  Created by Christian Braun on 25.10.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case parseUrl
    case parseJson
    case parseData
    case emptyResource
}

final class Webservice {
    static func load<A>(resource: Resource<A>?, completion: @escaping (Result<A>) -> Void) {
        guard let resource = resource else {
            completion(Result.error(NetworkError.emptyResource))
            return
        }
        guard let url = URL(string: resource.url) else {
            completion(Result.error(NetworkError.parseUrl))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = resource.method.rawValue
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil, let data = data else {
                // swiftlint:disable:next force_unwrapping
                completion(Result.error(error!))
                return
            }
            guard let result = resource.parseData(data) else {
                completion(Result.error(NetworkError.parseData))
                return
            }
            completion(Result.success(result))
        }.resume()
    }
}
