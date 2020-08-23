//
//  WidgetView.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 23.08.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import WidgetKit
import SwiftUI
import KingfisherSwiftUI

//swiftlint:disable let_var_whitespace
struct WidgetView: View {
    var entry: SimpleEntry

    @Environment(\.widgetFamily) var family

    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            MovieDescriptionView(movie: entry.movies[0])
                .padding(.all)
        case .systemMedium:
            HStack {
                ForEach(0..<2) { index in
                    MovieDescriptionView(movie: entry.movies[index])
                }
            }
            .padding(.all)
        case .systemLarge:
            VStack(alignment: .leading) {
                ForEach(0..<3) { index in
                    MovieView(movie: entry.movies[index])
                }
            }
            .padding(.all)
        @unknown default:
            fatalError("not handled yet")
        }
    }
}

struct MovieView: View {
    var movie: Movie

    var body: some View {
        HStack(spacing: 0) {
            if let path = movie.posterPath {
                let url = Movie.posterUrl(from: path, for: .small)
                KFImage(url)
                    .placeholder {
                        Image(uiImage: UIImage.posterPlaceholder)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Image(uiImage: UIImage.posterPlaceholder)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            Rectangle()
                .frame(width: 5)
                .foregroundColor(Color(.systemOrange))
            Spacer()
                .frame(width: 20)

            MovieDescriptionView(movie: movie)
        }
//        .padding(.all, 8)
        .background(Rectangle().fill(Color(.systemBackground)))
    }
}

struct MovieDescriptionView: View {
    var movie: Movie

    var body: some View {
        VStack(alignment: .leading) {
            Text(movie.formattedRelativeReleaseInformation + " ∙ " + movie.formattedRuntime)
                .font(.body)
                .foregroundColor(Color(.secondaryLabel))

            Text(movie.title)
                .font(.title)
                .kerning(-0.5)
                .bold()
                .multilineTextAlignment(.leading)

            MovieVoteAverageView(movie: movie)
        }
    }
}

struct MovieVoteAverageView: View {
    var movie: Movie

    var body: some View {
        let nonbreakingSpace = "\u{00a0}"
        let voteAverage = movie.formattedVoteAverage
            + "\(nonbreakingSpace)/\(nonbreakingSpace)10"

        Text(voteAverage)
            .foregroundColor(Color(.systemOrange))
            .font(.body)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color(.systemOrange), lineWidth: 2)
            )
    }
}

struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WidgetView(entry: .previewData)
                .previewContext(
                    WidgetPreviewContext(family: .systemSmall)
                )
            WidgetView(entry: .previewData)
                .previewContext(
                    WidgetPreviewContext(family: .systemMedium)
                )
            WidgetView(entry: .previewData)
                .previewContext(
                    WidgetPreviewContext(family: .systemLarge)
                )
        }
    }
}
