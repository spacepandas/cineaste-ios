//
//  Webservice.swift
//  Cineaste
//
//  Created by Christian Braun on 25.10.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

enum NetworkError: Error {
    case parseUrl
    case parseJson
    case parseData
    case emptyResource
}

enum Webservice {
    static var numberOfRequests = 0 {
        didSet {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible =
                    numberOfRequests > 0
            }
        }
    }

    @discardableResult
    static func load<A>(resource: Resource<A>?, completion: @escaping (Result<A>) -> Void) -> URLSessionTask? {
        guard let resource = resource else {
            completion(Result.error(NetworkError.emptyResource))
            return nil
        }
        guard let url = URL(string: resource.url) else {
            completion(Result.error(NetworkError.parseUrl))
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = resource.method.rawValue

        numberOfRequests += 1

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            numberOfRequests -= 1

            guard error == nil, let data = data else {
                // swiftlint:disable:next force_unwrapping
                completion(Result.error(error!))
                return
            }
            guard let result = resource.parse(data) else {
                completion(Result.error(NetworkError.parseData))
                return
            }
            completion(Result.success(result))
        }

        task.resume()
        return task
    }
}
