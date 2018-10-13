//
//  ImprintViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 07.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit
import SafariServices

class SettingsDetailViewController: UIViewController {
    @IBOutlet weak var settingsDetailTextView: DescriptionTextView! {
        didSet {
            settingsDetailTextView.delegate = self
            update(textViewContent)
        }
    }

    @IBOutlet private weak var movieDBImageView: UIImageView! {
        didSet {
            movieDBImageView.isHidden = true
        }
    }

    private var textViewContent: TextViewType = .imprint {
        didSet {
            if oldValue != textViewContent {
                update(textViewContent)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
    }

    func configure(with title: String, textViewContent: TextViewType) {
        self.title = title
        self.textViewContent = textViewContent
    }

    private func update(_ type: TextViewType) {
        guard let textView = settingsDetailTextView,
            let imageView = movieDBImageView
            else { return }

        textView.setup(with: type)

        if textViewContent == .imprint {
            imageView.isHidden = false
        }
    }

}

extension SettingsDetailViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {

        let safariVC = CustomSafariViewController(url: URL)
        present(safariVC, animated: true)

        return false
    }
}

extension SettingsDetailViewController: Instantiable {
    static var storyboard: Storyboard { return .settings }
    static var storyboardID: String? { return "ImprintViewController" }
}
