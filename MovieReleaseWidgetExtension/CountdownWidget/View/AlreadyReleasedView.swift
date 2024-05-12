//
//  AlreadyReleasedView.swift
//  MovieReleaseWidgetExtension
//
//  Created by Xaver Lohmüller on 12.09.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import SwiftUI
import WidgetKit

private struct TextHeightPreference: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct AlreadyReleasedView: View {
    let movie: Movie
    let image: Image

    @Environment(\.colorScheme) var colorScheme
    private var outlineRadius: CGFloat {
        colorScheme == .dark ? 0.6 : 1.2
    }
    @State private var textHeight: CGFloat = 45

    var accessibilityHint: String {
        let format = NSLocalizedString("movie_release_widget_released_accessibility_format", comment: "")
        return String(format: format, movie.title)
    }

    var body: some View {
        // swiftlint:disable:next closure_body_length
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

                VStack(alignment: .leading) {
                    Text(movie.title)
                        .font(Font.custom("Noteworthy", fixedSize: 24))
                        .bold()
                        .minimumScaleFactor(0.01)
                        .lineLimit(2)
                        .outlined(radius: outlineRadius)
                        .accessibility(hidden: true)
                    Text("movie_release_widget_is_released")
                        .font(Font.custom("Noteworthy", fixedSize: 15))
                        .bold()
                        .minimumScaleFactor(0.01)
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                        .padding([.bottom, .trailing], 7)
                        .background(GeometryReader {
                            Color.clear.preference(key: TextHeightPreference.self, value: $0.size.height)
                        })
                        .accessibility(hidden: true)
                }.padding(.horizontal)
            }
            .onPreferenceChange(TextHeightPreference.self) {
                textHeight = $0
            }
        }
        .widgetURL(WidgetURL.deepLink(for: movie.id))
    }
}

struct AlreadyReleasedView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AlreadyReleasedView(movie: .testMovie, image: Image(uiImage: .posterPlaceholderWidget))
                .previewContext(
                    WidgetPreviewContext(family: .systemSmall)
                )
            AlreadyReleasedView(movie: .testMovie, image: Image(uiImage: .posterPlaceholderWidget))
                .previewContext(
                    WidgetPreviewContext(family: .systemSmall)
                )
                .environment(\.colorScheme, .dark)
        }
    }
}
