//
//  UITableView+GenericDequeue.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 20.05.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeueCell<Cell>(identifier: String) -> Cell {
        guard let cell = dequeueReusableCell(withIdentifier: identifier) as? Cell else {
            fatalError("Error creating tableview cell with identifier \(identifier)")
        }

        return cell
    }
}
