//
//  PosterWithDescriptionView.swift
//  MovieReleaseWidgetExtension
//
//  Created by Felizia Bernutz on 04.10.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import SwiftUI
import WidgetKit

struct PosterWithDescriptionView: View {
    let title: String
    let description: String
    let image: Image
    let accessibilityHint: String

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottomLeading) {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .accessibilityRemoveTraits(.isImage)
                    .accessibility(hint: Text(accessibilityHint))

                HStack {
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.system(size: 16))
                            .fontWeight(.heavy)
                            .lineLimit(2)
                            .accessibility(hidden: true)
                        Text(description)
                            .font(.system(size: 14))
                            .minimumScaleFactor(0.01)
                            .accessibility(hidden: true)
                    }

                    Spacer()
                }
                .padding([.leading, .bottom], 12)
                .padding([.top, .trailing], 4)
                .background(Color.background.opacity(0.6))
            }
        }
    }
}

struct PosterWithDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PosterWithDescriptionView(
                title: Movie.testMovie.title,
                description: Movie.testMovie.difference,
                image: Image(uiImage: .posterPlaceholderWidget),
                accessibilityHint: "a11y"
            )
            .previewContext(
                WidgetPreviewContext(family: .systemSmall)
            )
            PosterWithDescriptionView(
                title: Movie.testMovie.title,
                description: Movie.testMovie.difference,
                image: Image(uiImage: .posterPlaceholderWidget),
                accessibilityHint: "a11y"
            )
            .previewContext(
                WidgetPreviewContext(family: .systemSmall)
            )
            .environment(\.colorScheme, .dark)
        }
    }
}
