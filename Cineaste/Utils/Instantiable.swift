//
//  Instantiable.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

// swiftlint:disable force_cast

protocol Instantiable: class {
    static var storyboard: Storyboard { get }
    static var storyboardID: String? { get }
}

extension Instantiable {
    static var storyboardID: String? { return nil }

    static func instantiate() -> Self {
        let sb = storyboard.load()
        let instance: Self
        if let id = storyboardID {
            instance = sb.instantiateViewController(withIdentifier: id) as! Self
        } else {
            instance = sb.instantiateInitialViewController() as! Self
        }

        if let vc = instance as? UIViewController {
            vc.loadViewIfNeeded()
        }

        return instance
    }

    static func instantiateInNavigationController() -> UINavigationController {
        let instance = instantiate() as! UIViewController
        let navi = UINavigationController(rootViewController: instance)
        return navi
    }
}
