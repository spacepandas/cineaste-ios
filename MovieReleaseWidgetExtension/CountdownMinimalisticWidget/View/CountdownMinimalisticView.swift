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

    var difference: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .weekOfMonth]
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        formatter.collapsesLargestUnit = true
        let releaseDate = movie.releaseDate ?? Date()
        let formattedReleaseDate = formatter.string(from: Date(), to: releaseDate + 24 * 60 * 60) ?? ""

        return formattedReleaseDate
    }

    var accessibilityHint: String {
        let format = NSLocalizedString("movie_release_widget_upcoming_accessibility_format", comment: "")
        return String(format: format, movie.title, difference)
    }

    var body: some SwiftUI.View {
        ZStack(alignment: .bottom) {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .accessibilityRemoveTraits(.isImage)
                .accessibility(hint: Text(accessibilityHint))

            HStack(alignment: .bottom, spacing: 0) {
                Text(difference.split(separator: " ")[0])
                    .bold()
                    .minimumScaleFactor(0.01)
                    .aspectRatio(contentMode: .fit)
                    .accessibility(hidden: true)
                VStack(alignment: .leading) {
                    Text(difference.split(separator: " ")[1].uppercased())
                        .bold()
                        .minimumScaleFactor(0.01)
                        .lineLimit(1)
                        .accessibility(hidden: true)
                    Text(movie.title)
                        .bold()
                        .minimumScaleFactor(0.01)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .padding([.bottom, .trailing], 7)
                        .accessibility(hidden: true)
                }
            }
        }
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
