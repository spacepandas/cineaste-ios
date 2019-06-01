//
//  Data+SanitizeReleaseDate.swift
//  Cineaste App
//
//  Created by Xaver Lohmüller on 01.06.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import Foundation

extension Data {
    mutating func sanitizeReleaseDates() {
        // swiftlint:disable force_unwrapping
        let dirty = #""release_date":"""#.data(using: .utf8)!
        let sanitized = #""release_date":null"#.data(using: .utf8)!
        // swiftlint:enable force_unwrapping
        while let rangeOfReleaseDate = range(of: dirty) {
            replaceSubrange(rangeOfReleaseDate, with: sanitized)
        }
    }

    func sanitizingReleaseDates() -> Data {
        var copy = self
        copy.sanitizeReleaseDates()
        return copy
    }
}
