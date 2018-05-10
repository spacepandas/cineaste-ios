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
        self.setTitleColor(UIColor.primaryDarkOrange, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
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
                self.tintColor = UIColor.white
                self.layer.borderColor = UIColor.white.cgColor
            } else {
                setup()
            }
        }
    }

    func setup() {
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)

        if isEnabled {
            self.tintColor = UIColor.primaryOrange
            self.layer.borderColor = UIColor.primaryOrange.cgColor
            self.layer.borderWidth = 4
            self.layer.cornerRadius = 25
        } else {
            self.tintColor = UIColor.lightGray
            self.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
}
