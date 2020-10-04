//
//  CountdownMinimalisticWidget.swift
//  MovieReleaseWidgetExtension
//
//  Created by Felizia Bernutz on 04.10.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import WidgetKit
import SwiftUI

struct CountdownMinimalisticWidget: Widget {
    let kind: String = "CountdownMinimalisticWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: DynamicMovieSelectionIntent.self,
            provider: MovieReleaseTimelineProvider(),
            content: makeView
        )
        .configurationDisplayName("movie_release_widget_countdown_minimalistic")
        .description("movie_release_widget_countdown_description")
        .supportedFamilies([.systemSmall])
    }

    private func makeView(for entry: CountdownEntry) -> some View {
        Group {
            switch entry.content {
            case .empty:
                EmptyStateMinimalisticView()
            case let .movie(movie, image):
                if movie.soonAvailable {
                    CountdownMinimalisticView(movie: movie, image: image)
                } else {
                    AlreadyReleasedMinimalisticView(movie: movie, image: image)
                }
            }
        }
    }
}
