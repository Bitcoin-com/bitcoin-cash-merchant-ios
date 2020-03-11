//
//  AgreementViewController.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 3/10/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import UIKit

class AgreementViewController: UIViewController {
    
    // MARK: - Properties
    private var overlayView = UIView()
    private var containerView = UIView()
    private var agreeButton = UIButton()
    private var mainLabel = UILabel()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        localize()
    }
    
    // MARK: - Actions
    @objc private func agreeButtonTapped() {
        UserManager.shared.isTermsAccepted = true
        dismiss(animated: true)
    }
    
    @objc func textLabelTapped(_ recognizer: UITapGestureRecognizer) {
        guard let text = mainLabel.attributedText?.string else { return }
        
        if let range = text.range(of: Localized.serviceTerms), recognizer.didTapAttributedTextInLabel(label: mainLabel, inRange: NSRange(range, in: text)) {
            openLinkInSafari(link: Endpoints.serviceTerms)
        } else if let range = text.range(of: Localized.termsOfUse), recognizer.didTapAttributedTextInLabel(label: mainLabel, inRange: NSRange(range, in: text)) {
            openLinkInSafari(link: Endpoints.termsOfUse)
        } else {
            openLinkInSafari(link: Endpoints.privacyPolicy)
        }
    }
    
    // MARK: - Private API
    private func setupView() {
        setupOverlayView()
        setupContainerView()
        setupAgreeButton()
        setupMainLabel()
    }
    
    private func setupOverlayView() {
        overlayView.backgroundColor = .black
        overlayView.alpha = 0.4
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayView)
        NSLayoutConstraint.activate([
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupContainerView() {
        let mainLabelHeight = configureMainAttributedString().height(containerWidth: Constants.CONTAINER_VIEW_WIDTH - 2 * Constants.MAIN_LABEL_PADDING)
        let containerHeight = mainLabelHeight + Constants.MAIN_LABEL_PADDING + Constants.AGREE_BUTTON_BOTTOM_MARGIN + Constants.AGREE_BUTTON_HEIGHT
        
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: Constants.CONTAINER_VIEW_WIDTH),
            containerView.heightAnchor.constraint(equalToConstant: containerHeight)
        ])
    }
    
    private func setupAgreeButton() {
        agreeButton.titleLabel?.font = .boldSystemFont(ofSize: Constants.FONT_SIZE)
        agreeButton.setTitleColor(.bitcoinGreen, for: .normal)
        agreeButton.translatesAutoresizingMaskIntoConstraints = false
        agreeButton.addTarget(self, action: #selector(agreeButtonTapped), for: .touchUpInside)
        containerView.addSubview(agreeButton)
        NSLayoutConstraint.activate([
            agreeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.AGREE_BUTTON_TRAILING_MARGIN),
            agreeButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.AGREE_BUTTON_BOTTOM_MARGIN)
        ])
    }
    
    private func setupMainLabel() {
        mainLabel.numberOfLines = 0
        mainLabel.isUserInteractionEnabled = true
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(mainLabel)
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.MAIN_LABEL_PADDING),
            mainLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.MAIN_LABEL_PADDING),
            mainLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.MAIN_LABEL_PADDING),
        ])
        
        mainLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(textLabelTapped(_:))))
    }
    
    private func configureMainAttributedString() -> NSAttributedString {
        let text = String(format: Localized.contractAgreementSummary, Localized.serviceTerms, Localized.termsOfUse, Localized.privacyPolicy)
        
        let normalAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: Constants.FONT_SIZE),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        
        let string = NSMutableAttributedString(string: text, attributes: normalAttributes)
        
        let underlineAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: Constants.FONT_SIZE),
            NSAttributedString.Key.foregroundColor: UIColor.bitcoinGreen,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let serviceTermsRange = (text as NSString).range(of: Localized.serviceTerms)
        let termsOfUseRange = (text as NSString).range(of: Localized.termsOfUse)
        let privacyPolicyRange = (text as NSString).range(of: Localized.privacyPolicy)
        
        string.setAttributes(underlineAttributes, range: serviceTermsRange)
        string.setAttributes(underlineAttributes, range: termsOfUseRange)
        string.setAttributes(underlineAttributes, range: privacyPolicyRange)
        
        return string
    }
    
    private func localize() {
        agreeButton.setTitle(Localized.iAgree.uppercased(), for: .normal)
        mainLabel.attributedText = configureMainAttributedString()
    }

}

private struct Localized {
    static var iAgree: String { NSLocalizedString("contract_button_ok", comment: "") }
    static var contractAgreementSummary: String { NSLocalizedString("contract_agreement_summary", comment: "") }
    static var serviceTerms: String { NSLocalizedString("menu_service_terms", comment: "") }
    static var termsOfUse: String { NSLocalizedString("menu_terms_of_use", comment: "") }
    static var privacyPolicy: String { NSLocalizedString("menu_privacy_policy", comment: "") }
}

private struct Constants {
    static let CONTAINER_VIEW_WIDTH: CGFloat = UIScreen.main.bounds.size.width - 100.0
    static let AGREE_BUTTON_TRAILING_MARGIN: CGFloat = 20.0
    static let AGREE_BUTTON_BOTTOM_MARGIN: CGFloat = 10.0
    static let AGREE_BUTTON_HEIGHT: CGFloat = 50.0
    static let MAIN_LABEL_PADDING: CGFloat = 20.0
    static let FONT_SIZE: CGFloat = 20.0
}
