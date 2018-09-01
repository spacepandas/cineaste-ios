//
//  NonClearView.swift
//  Cineaste App
//
//  Created by Xaver Lohmüller on 19.08.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit

class NonClearView: UIView {
    override var backgroundColor: UIColor? {
        didSet {
            if backgroundColor?.cgColor.alpha == 0 {
                backgroundColor = oldValue
            }
        }
    }
}
