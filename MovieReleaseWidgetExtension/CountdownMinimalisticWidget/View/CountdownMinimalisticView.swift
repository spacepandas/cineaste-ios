//
//  CountdownMinimalisticView.swift
//  MovieReleaseWidgetExtension
//
//  Created by Felizia Bernutz on 31.08.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import SwiftUI
import WidgetKit

struct CountdownMinimalisticView: SwiftUI.View {
    let movie: Movie
    let image: Image

    @Environment(\.colorScheme) var colorScheme

    var accessibilityHint: String {
        let format = NSLocalizedString("movie_release_widget_upcoming_accessibility_format", comment: "")
        return String(format: format, movie.title, movie.difference)
    }

    var body: some SwiftUI.View {
        PosterWithDescriptionView(
            title: movie.difference,
            description: LocalizedStringKey(movie.title),
            image: image,
            accessibilityHint: accessibilityHint
        )
        .widgetURL(WidgetURL.deepLink(for: movie.id))
    }
}

struct CountdownMinimalisticView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        Group {
            CountdownMinimalisticView(movie: .testMovie, image: Image(uiImage: .posterPlaceholderWidget))
                .previewContext(
                    WidgetPreviewContext(family: .systemSmall)
                )
            CountdownMinimalisticView(movie: .testMovie, image: Image(uiImage: .posterPlaceholderWidget))
                .previewContext(
                    WidgetPreviewContext(family: .systemSmall)
                )
                .environment(\.colorScheme, .dark)
        }
    }
}
