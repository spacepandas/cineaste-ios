//
//  ImprintViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 07.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class ImprintViewController: UIViewController {
    @IBOutlet var imprintTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("About", comment: "Title for imprint viewController")
    }

}

extension ImprintViewController: Instantiable {
    static var storyboard: Storyboard { return .imprint }
    static var storyboardID: String? { return "ImprintViewController" }
}
