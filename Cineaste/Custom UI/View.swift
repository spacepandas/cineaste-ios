//
//  View.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 07.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class View: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        fatalError("Override this method in your subclass")
    }
}

class VoteView: View {
    override func setup() {
        clipsToBounds = true
        layer.cornerRadius = self.frame.height / 2

        backgroundColor = UIColor.basicYellow

        layer.shadowColor = UIColor.accentTextOnWhite.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        layer.shadowRadius = 3
    }
}

@IBDesignable
class ShadowView: View {
    @IBInspectable var shadowOpacity: Float = 0.3 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }

    @IBInspectable var shadowRadius: CGFloat = 3.0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }

    override func setup() {
        layer.shadowColor = UIColor.accentTextOnWhite.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        layer.shadowRadius = shadowRadius
    }
}
