//
//  AlreadyReleasedMinimalisticView.swift
//  MovieReleaseWidgetExtension
//
//  Created by Xaver Lohmüller on 12.09.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import SwiftUI
import WidgetKit

struct AlreadyReleasedMinimalisticView: View {
    let movie: Movie
    let image: Image

    @Environment(\.colorScheme) var colorScheme

    var accessibilityHint: String {
        let format = NSLocalizedString("movie_release_widget_released_accessibility_format", comment: "")
        return String(format: format, movie.title)
    }

    var body: some View {
        PosterWithDescriptionView(
            title: movie.title,
            description: "movie_release_widget_is_released",
            image: image,
            accessibilityHint: accessibilityHint
        )
        .widgetURL(WidgetURL.deepLink(for: movie.id))
    }
}

struct AlreadyReleasedMinimalisticView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AlreadyReleasedMinimalisticView(movie: .testMovie, image: Image(uiImage: .posterPlaceholderWidget))
                .previewContext(
                    WidgetPreviewContext(family: .systemSmall)
                )
            AlreadyReleasedMinimalisticView(movie: .testMovie, image: Image(uiImage: .posterPlaceholderWidget))
                .previewContext(
                    WidgetPreviewContext(family: .systemSmall)
                )
                .environment(\.colorScheme, .dark)
        }
    }
}
