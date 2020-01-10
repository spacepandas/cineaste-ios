//
//  Instantiable.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

protocol Instantiable: AnyObject {
    static var storyboard: Storyboard { get }
    static var storyboardID: String? { get }
}

extension Instantiable {
    static var storyboardID: String? { nil }

    static func instantiate() -> Self {
        let sb = storyboard.load()
        let instance: Self
        if let id = storyboardID {
            // swiftlint:disable:next force_cast
            instance = sb.instantiateViewController(withIdentifier: id) as! Self
        } else {
            // swiftlint:disable:next force_cast
            instance = sb.instantiateInitialViewController() as! Self
        }

        if let vc = instance as? UIViewController {
            vc.loadViewIfNeeded()
        }

        return instance
    }

    static func instantiateInNavigationController() -> UINavigationController {
        // swiftlint:disable:next force_cast
        let instance = instantiate() as! UIViewController
        let navi = UINavigationController(rootViewController: instance)
        return navi
    }
}
