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

class VoteCircleView: View {
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

    override var backgroundColor: UIColor? {
        didSet {
            if backgroundColor?.cgColor.alpha == 0 {
                backgroundColor = oldValue
            }
        }
    }

    override func setup() {
        clipsToBounds = true

        backgroundColor = UIColor.groupTableViewBackground

        layer.cornerRadius = 2

        hintLabel.numberOfLines = 0
        hintLabel.adjustsFontSizeToFitWidth = true
        hintLabel.minimumScaleFactor = 0.5
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hintLabel)

        let horizontalConstant: CGFloat = 4
        let verticalConstant: CGFloat = 2

        let bottomConstraint = hintLabel.bottomAnchor
            .constraint(equalTo: bottomAnchor,
                        constant: -verticalConstant)
        bottomConstraint.priority = UILayoutPriority(rawValue: 999)

        NSLayoutConstraint.activate([
            hintLabel.leadingAnchor
                .constraint(equalTo: leadingAnchor,
                            constant: horizontalConstant),
            hintLabel.trailingAnchor
                .constraint(equalTo: trailingAnchor,
                            constant: -horizontalConstant),
            bottomConstraint,
            hintLabel.topAnchor
                .constraint(equalTo: topAnchor,
                            constant: verticalConstant)
            ])

        hintLabel
            .setContentCompressionResistancePriority(.required,
                                                     for: .vertical)
    }
}

class VoteView: View {
    var content: String = "" {
        didSet {
            voteLabel.text = content
        }
    }

    private let voteLabel = DescriptionLabel()

    override func setup() {
        clipsToBounds = true

        layer.cornerRadius = frame.height / 3

        let borderWidth: CGFloat
        switch voteLabel.font.pointSize {
        case ...20:
            borderWidth = 1
        case 20..<25:
            borderWidth = 2
        default:
            borderWidth = 3
        }
        layer.borderWidth = borderWidth

        layer.borderColor = UIColor.primaryOrange.cgColor

        voteLabel.textColor = .primaryOrange
        voteLabel.adjustsFontSizeToFitWidth = true
        voteLabel.minimumScaleFactor = 0.5
        voteLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(voteLabel)

        let horizontalConstant: CGFloat = 8
        let verticalConstant: CGFloat = 4

        let bottomConstraint = voteLabel.bottomAnchor
            .constraint(equalTo: bottomAnchor,
                        constant: -verticalConstant)
        bottomConstraint.priority = UILayoutPriority(rawValue: 999)

        NSLayoutConstraint.activate([
            voteLabel.leadingAnchor
                .constraint(equalTo: leadingAnchor,
                            constant: horizontalConstant),
            voteLabel.trailingAnchor
                .constraint(equalTo: trailingAnchor,
                            constant: -horizontalConstant),
            bottomConstraint,
            voteLabel.topAnchor
                .constraint(equalTo: topAnchor,
                            constant: verticalConstant)
            ])

        voteLabel
            .setContentCompressionResistancePriority(.required,
                                                     for: .vertical)
    }
}
