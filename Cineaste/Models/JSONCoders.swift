//
//  JSONCoders.swift
//  Cineaste App
//
//  Created by Xaver Lohmüller on 18.04.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import Foundation

private let formatter: DateFormatter = {
    $0.dateFormat = "yyyy-MM-dd"
    $0.timeZone = TimeZone(abbreviation: "UTC")
    return $0
}(DateFormatter())

extension JSONDecoder {
    static let tmdbDecoder: JSONDecoder = {
        $0.keyDecodingStrategy = .convertFromSnakeCase
        $0.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            if let date = formatter.date(from: dateString) {
                return date
            } else {
                //TODO: maybe fix this at some time?
                return Date.distantFuture
            }
        }
        return $0
    }(JSONDecoder())
}

extension JSONEncoder {
    static let tmdbEncoder: JSONEncoder = {
        $0.keyEncodingStrategy = .convertToSnakeCase
        $0.dateEncodingStrategy = .formatted(formatter)
        $0.outputFormatting = .prettyPrinted
        return $0
    }(JSONEncoder())
}
