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

    required init?(coder aDecoder: NSCoder) {
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
        layer.cornerRadius = frame.height / 2

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

class SeparatorView: View {
    override func setup() {
        backgroundColor = UIColor.primaryOrange
    }

    override var backgroundColor: UIColor? {
        didSet {
            if backgroundColor?.cgColor.alpha == 0 {
                backgroundColor = oldValue
            }
        }
    }
}

class HintView: View {
    var content: String = "" {
        didSet {
            hintLabel.text = content
        }
    }

    private let hintLabel = HintLabel()

    override func setup() {
        clipsToBounds = true

        backgroundColor = UIColor.groupTableViewBackground

        layer.cornerRadius = 2

        hintLabel.numberOfLines = 0
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hintLabel)

        let horizontalConstant: CGFloat = 4
        let verticalConstant: CGFloat = 2

        NSLayoutConstraint.activate([
            hintLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: horizontalConstant),
            hintLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                constant: -horizontalConstant),
            hintLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                              constant: -verticalConstant),
            hintLabel.topAnchor.constraint(equalTo: topAnchor,
                                           constant: verticalConstant)
            ])
    }
}
