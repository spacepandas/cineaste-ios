//
//  CineasteWidget.swift
//  CineasteWidget
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
            provider: MovieReleaseTimelineProvider()
        ) { entry in
            Group {
                if entry.movie.releaseDate! > Date() {
                    CountdownView(entry: entry)
                } else {
                    AlreadyReleasedView(entry: entry)
                }
            }
        }
        .configurationDisplayName("movie_release_widget_show_countdown")
        .description("movie_release_widget_countdown_description")
        .supportedFamilies([.systemSmall])
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
