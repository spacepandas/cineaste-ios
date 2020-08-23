//
//  AppGroup.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 23.08.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import Foundation

// swiftlint:disable force_unwrapping
public enum AppGroup: String {
    case widget = "group.de.spacepandas.ios.cineaste-dev"

    public var containerURL: URL {
        FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: self.rawValue
        )!
    }
}
