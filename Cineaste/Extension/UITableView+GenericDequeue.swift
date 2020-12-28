//
//  UITableView+GenericDequeue.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 20.05.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

extension UITableView {

    /// This casts a dequeued reusable cell for identifier to its correct type.
    /// When this cast is not successful, there is an implementation error and
    /// the app crashes.
    ///
    /// - Parameter identifier: The identifier used to identify a reusable cell
    /// - Returns: The dequeued reusable Cell
    func dequeueCell<Cell>(identifier: String) -> Cell {
        guard let cell = dequeueReusableCell(withIdentifier: identifier) as? Cell else {
            fatalError("Error creating tableview cell with identifier \(identifier)")
        }

        return cell
    }
}
