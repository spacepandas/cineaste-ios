//
//  CountdownWidget.swift
//  MovieReleaseWidgetExtension
//
//  Created by Felizia Bernutz on 23.08.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import WidgetKit
import SwiftUI

struct CountdownWidget: Widget {
    let kind: String = "CountdownWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: DynamicMovieSelectionIntent.self,
            provider: MovieReleaseTimelineProvider(),
            content: makeView
        )
        .configurationDisplayName("movie_release_widget_countdown")
        .description("movie_release_widget_countdown_description")
        .supportedFamilies([.systemSmall])
    }

    private func makeView(for entry: CountdownEntry) -> some View {
        Group {
            switch entry.content {
            case .empty:
                EmptyStateView()
            case let .movie(movie, image):
                if movie.soonAvailable {
                    CountdownView(movie: movie, image: image)
                } else {
                    AlreadyReleasedView(movie: movie, image: image)
                }
            }
        }
    }
}
