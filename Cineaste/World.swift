//
//  World.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 28.12.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import Foundation

/// Encapsulates dependencies to make it easier to mock and replace them
/// in tests.
///
/// See more about this concept:
/// https://www.pointfree.co/blog/posts/21-how-to-control-the-world
struct World {
    var date = { Date() }
    var locale: Locale = .current
    var timeZone: TimeZone = .current
}

// swiftlint:disable identifier_name
#if DEBUG
var Current = World()
#else
let Current = World()
#endif
