//
//  CountdownView.swift
//  CineasteWidgetExtension
//
//  Created by Felizia Bernutz on 31.08.20.
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

struct CountdownView: SwiftUI.View {
    var entry: CountdownEntry
    @State private var textHeight: CGFloat = 0

    var difference: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .weekOfMonth]
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        formatter.collapsesLargestUnit = true
        let releaseDate = entry.movie.releaseDate ?? Date()
        let formattedReleaseDate = formatter.string(from: Date(), to: releaseDate + 24 * 60 * 60) ?? ""

        return formattedReleaseDate
    }

    var body: some SwiftUI.View {
        ZStack(alignment: .bottomLeading) {
            GeometryReader { proxy in
                entry.image
                    .resizable()
                    .blur(radius: 1.5)
                Color.white
                    .opacity(0.75)
                    .offset(y: proxy.size.height - textHeight)
                    .frame(width: proxy.size.width, height: textHeight)
                HStack(alignment: .bottom, spacing: 0) {
                    Text(difference.split(separator: " ").first ?? "")
                        .font(.system(size: 500))
                        .minimumScaleFactor(0.01)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: proxy.size.width * 0.4, height: proxy.size.height)
                        .border(Color.white)
                    VStack {
                        Text(difference.split(separator: " ").last?.uppercased() ?? "")
                        Text(entry.movie.title)
                            .multilineTextAlignment(.leading)
                            .background(GeometryReader { proxy in
                                Color.clear
                                    .preference(key: TextHeightPreference.self, value: proxy.size.height)
                            })
                    }
                    .border(Color.black)
                }
            }
            .onPreferenceChange(TextHeightPreference.self) {
                textHeight = $0
            }
            .border(Color.orange)
        }
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        CountdownView(entry: .previewData)
            .previewContext(
                WidgetPreviewContext(family: .systemSmall)
            )
    }
}
