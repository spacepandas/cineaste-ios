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
    let date: Date
    let movie: Movie
    let image: Image

    static let previewData = CountdownEntry(
        date: Date(),
        movie: .testSeen,
        image: Image(uiImage: .posterPlaceholder)
    )
}
