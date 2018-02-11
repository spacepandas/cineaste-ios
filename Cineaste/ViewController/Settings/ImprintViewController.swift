//
//  ImprintViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 07.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class ImprintViewController: UIViewController {
    @IBOutlet var imprintTextView: UITextView! {
        didSet {
            imprintTextView.text = textViewContent.content
        }
    }

    var textViewContent: TextViewContent = .imprint

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension ImprintViewController: Instantiable {
    static var storyboard: Storyboard { return .settings }
    static var storyboardID: String? { return "ImprintViewController" }
}
