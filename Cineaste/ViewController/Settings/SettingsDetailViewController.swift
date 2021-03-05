//
//  ImprintViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 07.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class SettingsDetailViewController: UIViewController {
    @IBOutlet weak var settingsDetailTextView: DescriptionTextView!
    @IBOutlet private weak var movieDBImageView: UIImageView!

    private var textViewContent: TextViewType = .imprint {
        didSet {
            guard oldValue != textViewContent else { return }

            update(textViewContent)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureElements()
    }

    func configure(with title: String, textViewContent: TextViewType) {
        self.title = title
        self.textViewContent = textViewContent
    }

    private func configureElements() {
        view.backgroundColor = .cineContentBackground
        navigationItem.largeTitleDisplayMode = .never

        settingsDetailTextView.delegate = self
        movieDBImageView.isHidden = true
        update(textViewContent)
    }

    private func update(_ type: TextViewType) {
        guard let textView = settingsDetailTextView,
            let imageView = movieDBImageView
            else { return }

        textView.type = type

        if textViewContent == .imprint {
            imageView.isHidden = false
            updateAssetForUserInterfaceStyle()
        }
    }

    private func updateAssetForUserInterfaceStyle() {
        movieDBImageView?.tintColor = .cineImageTint
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        updateAssetForUserInterfaceStyle()
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
    static var storyboard: Storyboard { .settings }
    static var storyboardID: String? { "ImprintViewController" }
}
