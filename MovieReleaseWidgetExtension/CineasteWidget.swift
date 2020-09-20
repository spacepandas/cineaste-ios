//
//  CineasteWidget.swift
//  MovieReleaseWidgetExtension
//
//  Created by Felizia Bernutz on 23.08.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import WidgetKit
import SwiftUI

@main
struct CineasteWidget: Widget {
    let kind: String = "CineasteWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: DynamicMovieSelectionIntent.self,
            provider: MovieReleaseTimelineProvider(),
            content: makeView
        )
        .configurationDisplayName("movie_release_widget_show_countdown")
        .description("movie_release_widget_countdown_description")
        .supportedFamilies([.systemSmall])
    }

    private func makeView(for entry: CountdownEntry) -> some View {
        Group {
            switch entry.content {
            case .empty:
                EmptyStateView()
            case let .movie(movie, image):
                if let releaseDate = movie.releaseDate, releaseDate > Date() {
                    CountdownView(movie: movie, image: image)
                } else {
                    AlreadyReleasedView(movie: movie, image: image)
                }
            }
        }
    }
}

//struct CineasteWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        WidgetView(entry: .previewData)
//        .previewContext(
//            WidgetPreviewContext(family: .systemSmall)
//        )
//    }
//}
