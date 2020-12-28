//
//  UIView+Constraints.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 27.12.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import UIKit

extension UIView {

    /// "Modify" the multiplier of a `NSLayoutConstraint`.
    ///
    /// As the multiplier of a constraint is read only, we have to create a
    /// new constraint with the new multiplier.
    /// The old constraint is deactivated and the new one is activated, to
    /// prevent constraint warnings.
    /// - Parameters:
    ///   - constraint: The constraint which needs to be modified
    ///   - newMultiplier: The new multiplier which will be used in the constraint
    /// - Returns: A new activated constraint with the multiplier.
    func updateMultiplierOfConstraint(_ constraint: NSLayoutConstraint, newMultiplier: CGFloat) -> NSLayoutConstraint {
        let newConstraint = NSLayoutConstraint(
            // swiftlint:disable:next force_unwrapping
            item: constraint.firstItem!,
            attribute: constraint.firstAttribute,
            relatedBy: constraint.relation,
            toItem: constraint.secondItem,
            attribute: constraint.secondAttribute,
            multiplier: newMultiplier,
            constant: constraint.constant
        )
        NSLayoutConstraint.deactivate([constraint])
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}
