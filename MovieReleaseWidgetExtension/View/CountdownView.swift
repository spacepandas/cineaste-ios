//
//  CountdownView.swift
//  MovieReleaseWidgetExtension
//
//  Created by Felizia Bernutz on 31.08.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import SwiftUI
import WidgetKit

// swiftlint:disable closure_body_length multiline_arguments_brackets

private struct TextHeightPreference: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct CountdownView: SwiftUI.View {
    let movie: Movie
    let image: Image

    @Environment(\.colorScheme) var colorScheme
    private var outlineRadius: CGFloat {
        colorScheme == .dark ? 0.6 : 1.2
    }
    @State private var textHeight: CGFloat = 45

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
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .blur(radius: 1)
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .accessibilityRemoveTraits(.isImage)
                    .accessibility(hint: Text(accessibilityHint))

                Color.background
                    .opacity(0.75)
                    .frame(height: textHeight)

                HStack(alignment: .bottom, spacing: 0) {
                    Text(difference.split(separator: " ")[0])
                        .font(Font.custom("Noteworthy", fixedSize: 500))
                        .bold()
                        .minimumScaleFactor(0.01)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: proxy.size.width * 0.4)
                        .outlined(radius: outlineRadius)
                        .accessibility(hidden: true)
                    VStack(alignment: .leading) {
                        Text(difference.split(separator: " ")[1].uppercased())
                            .font(Font.custom("Noteworthy", fixedSize: 24))
                            .bold()
                            .minimumScaleFactor(0.01)
                            .lineLimit(1)
                            .outlined(radius: outlineRadius)
                            .accessibility(hidden: true)
                        Text(movie.title)
                            .font(Font.custom("Noteworthy", fixedSize: 15))
                            .bold()
                            .minimumScaleFactor(0.01)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .padding([.bottom, .trailing], 7)
                            .background(GeometryReader {
                                Color.clear.preference(key: TextHeightPreference.self, value: $0.size.height)
                            })
                            .accessibility(hidden: true)
                    }
                }
            }
        }
        .onPreferenceChange(TextHeightPreference.self) {
            textHeight = $0
        }
        .widgetURL(WidgetURL.deepLink(for: movie.id))
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        Group {
            CountdownView(movie: .testMovie, image: Image(uiImage: .posterPlaceholderWidget))
                .previewContext(
                    WidgetPreviewContext(family: .systemSmall)
                )
            CountdownView(movie: .testMovie, image: Image(uiImage: .posterPlaceholderWidget))
                .previewContext(
                    WidgetPreviewContext(family: .systemSmall)
                )
                .environment(\.colorScheme, .dark)
        }
    }
}
