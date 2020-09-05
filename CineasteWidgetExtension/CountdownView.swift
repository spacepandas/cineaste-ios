//
//  CountdownView.swift
//  CineasteWidgetExtension
//
//  Created by Felizia Bernutz on 31.08.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import SwiftUI
import WidgetKit

struct CountdownView: SwiftUI.View {
    var entry: CountdownEntry

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
                    .blur(radius: 3.0)
                Color.white
                    .opacity(0.5)
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
                    }
                    .border(Color.black)
                }
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
