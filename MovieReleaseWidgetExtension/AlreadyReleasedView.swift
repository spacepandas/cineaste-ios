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
    var entry: CountdownEntry
    @State private var textHeight: CGFloat = 0

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                entry.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .blur(radius: 1)
                    .frame(width: proxy.size.width, height: proxy.size.height)

                Color.white
                    .opacity(0.75)
                    .frame(height: textHeight)

                VStack(alignment: .leading) {
                    Text(entry.movie.title)
                        .font(Font.custom("Noteworthy", fixedSize: 24))
                        .bold()
                        .minimumScaleFactor(0.01)
                        .lineLimit(2)
                        .outlined(1.2)
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
                }.padding(.horizontal)
            }
            .onPreferenceChange(TextHeightPreference.self) {
                textHeight = $0
            }
        }
        .widgetURL(URL(string: "widget-deeplink://\(entry.movie.id)")!)
    }
}

struct AlreadyReleasedView_Previews: PreviewProvider {
    static var previews: some View {
        AlreadyReleasedView(entry: .previewData)
            .previewContext(
                WidgetPreviewContext(family: .systemSmall)
            )
    }
}
