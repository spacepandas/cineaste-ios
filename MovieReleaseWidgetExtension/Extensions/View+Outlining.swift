//
//  View+Outlining.swift
//  MovieReleaseWidgetExtension
//
//  Created by Xaver Lohmüller on 13.09.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import SwiftUI

extension Color {
    static let background = Color(.systemBackground)
}

extension View {
    func outlined(color: Color = .background, radius: CGFloat) -> some View {
        self
            .shadow(color: color, radius: 0, x: -radius, y: -radius)
            .shadow(color: color, radius: 0, x: radius, y: radius)
            .shadow(color: color, radius: 0, x: -radius, y: radius)
            .shadow(color: color, radius: 0, x: radius, y: -radius)
    }
}
