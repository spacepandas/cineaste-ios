//
//  UIView+BlurEffect.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 21.07.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit

extension UIView {
    func addBlurEffect(with style: UIBlurEffectStyle) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds

        // for supporting device rotation
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
}
