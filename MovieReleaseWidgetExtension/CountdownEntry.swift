//
//  CountdownEntry.swift
//  MovieReleaseWidgetExtension
//
//  Created by Xaver Lohmüller on 05.09.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import WidgetKit
import SwiftUI

struct CountdownEntry: TimelineEntry {

    enum Content {
        case empty
        case movie(movie: Movie, image: Image)
    }

    let date: Date
    let content: Content

    static var empty: CountdownEntry {
        CountdownEntry(date: Date(), content: .empty)
    }

    static let previewData = CountdownEntry(
        date: Date(),
        content: .movie(movie: .testSeen, image: Image(uiImage: .posterPlaceholder))
    )
}
