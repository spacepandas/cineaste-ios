//
//  NSLayoutConstraint+Multiplier.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 26.12.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {

    /// To modify the multiplier of a constraint.
    ///
    /// As the multiplier is read only, we have to create a new constraint
    /// with the new multiplier.
    /// - Parameter multiplier: The new multiplier for the constraint
    /// - Returns: A new constraint with modified multiplier
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        NSLayoutConstraint(
            // swiftlint:disable:next force_unwrapping
            item: firstItem!,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant
        )
    }
}
