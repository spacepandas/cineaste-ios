//
//  Label.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

class Label: UILabel {
    func setup() {
        fatalError("Override this method in your subclass")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }
}

class DescriptionLabel: Label {
    override func setup() {
        font = UIFont.systemFont(ofSize: 13.0)
        textColor = UIColor.accentTextOnWhite
    }
}

class TitleLabel: Label {
    override func setup() {
        font = UIFont.systemFont(ofSize: 18.0)
        textColor = UIColor.black
    }
}
