//
//  WidgetURL.swift
//  MovieReleaseWidgetExtension
//
//  Created by Xaver Lohmüller on 20.09.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import Foundation

// swiftlint:disable force_unwrapping
enum WidgetURL {
    static func deepLink(for movieID: Int64) -> URL {
        URL(string: "widget-deeplink://\(movieID)")!
    }

    static let search = URL(string: "widget-deeplink://search")!
}
// swiftlint:enable force_unwrapping
