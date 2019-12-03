//
//  UIView+SlideIn.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 10.03.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import UIKit

extension UIView {
    enum Side {
        case leading
        case trailing
    }

    func slideIn(from side: Side, completion: (() -> Void)? = nil) {
        let distance: CGFloat
        switch side {
        case .trailing:
            distance = -40.0
        case .leading:
            distance = 40.0
        }

        let startDuration = 0.4
        let startDelay = 0.4

        let endDuration = 0.2
        let endDelay = 0.0

        UIView.animate(withDuration: startDuration, delay: startDelay, options: [.curveEaseOut], animations: {
            self.transform = CGAffineTransform(translationX: distance, y: 0)
        }, completion: { _ in
            UIView.animate(withDuration: endDuration, delay: endDelay, options: [.curveLinear], animations: {
                self.transform = .identity
            }, completion: { _ in
                completion?()
            }) // swiftlint:disable:this multiline_arguments_brackets
        }) // swiftlint:disable:this multiline_arguments_brackets
    }
}
