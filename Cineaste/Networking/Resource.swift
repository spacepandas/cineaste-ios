//
//  Resource.swift
//  Cineaste
//
//  Created by Christian Braun on 25.10.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

struct Resource<A> {
    let url: String
    let method: HTTPMethod
    let parse: (Data) -> A?
}
