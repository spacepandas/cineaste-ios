//
//  Button.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 07.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

public class ActionButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public override func setTitle(_ title: String?, for state: UIControlState) {
        super.setTitle(title?.uppercased(), for: state)
    }

    func setup() {
        setTitleColor(UIColor.primaryDarkOrange, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }
}

public class StartMovieNightButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public override var isEnabled: Bool {
        didSet {
            setup()
        }
    }

    public override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                tintColor = UIColor.white
                layer.borderColor = UIColor.white.cgColor
            } else {
                setup()
            }
        }
    }

    func setup() {
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)

        if isEnabled {
            tintColor = UIColor.primaryOrange
            layer.borderColor = UIColor.primaryOrange.cgColor
            layer.borderWidth = 4
            layer.cornerRadius = 25
        } else {
            tintColor = UIColor.lightGray
            layer.borderColor = UIColor.lightGray.cgColor
        }
    }
}
