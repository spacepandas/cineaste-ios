// swiftlint:disable:this file_name
//
//  JSONCoders.swift
//  Cineaste App
//
//  Created by Xaver Lohmüller on 18.04.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import Foundation

extension JSONEncoder {
    static let tmdbEncoder: JSONEncoder = {
        $0.dateEncodingStrategy = .formatted(DateFormatter.importFormatter)
        $0.outputFormatting = .prettyPrinted
        return $0
    }(JSONEncoder())
}
