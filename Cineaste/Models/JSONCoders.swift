// swiftlint:disable:this file_name
//
//  JSONCoders.swift
//  Cineaste App
//
//  Created by Xaver Lohmüller on 18.04.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import Foundation

extension JSONDecoder {
    static let tmdbDecoder: JSONDecoder = {
        $0.keyDecodingStrategy = .convertFromSnakeCase
        $0.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            return DateFormatter.utcFormatter.date(from: dateString) ?? Date.distantFuture
        }
        return $0
    }(JSONDecoder())

    static let importDecoder: JSONDecoder = {
        $0.keyDecodingStrategy = .convertFromSnakeCase
        $0.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            return dateString.dateFromImportedMoviesString ?? Date.distantFuture
        }
        return $0
    }(JSONDecoder())
}

extension JSONEncoder {
    static let tmdbEncoder: JSONEncoder = {
        $0.keyEncodingStrategy = .convertToSnakeCase
        $0.dateEncodingStrategy = .formatted(DateFormatter.utcFormatter)
        $0.outputFormatting = .prettyPrinted
        return $0
    }(JSONEncoder())
}
