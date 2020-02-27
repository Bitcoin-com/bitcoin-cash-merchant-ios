//
//  PaymentCompletedView.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/26/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation
import UIKit

final class PaymentCompletedView: UIView {

    // MARK: - Properties
    private var checkmarkContainerView = UIView()
    private var paymentReceivedLabel = UILabel()
    private var doneButton = UIButton()
    var onDone: (() -> Void)?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    // MARK: - Actions
    @objc private func doneButtonTapped() {
        onDone?()
    }
    
    // MARK: - Private API
    private func setupView() {
        backgroundColor = .bitcoinGreen
        
        
        setupCheckmarkContainerView()
        setupPaymentReceivedLabel()
        setupDoneButton()
        localize()
    }
    
    private func setupCheckmarkContainerView() {
        checkmarkContainerView.layer.cornerRadius = Constants.CHECKMARK_CONTAINER_VIEW_SIZE / 2
        checkmarkContainerView.backgroundColor = .white
        checkmarkContainerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(checkmarkContainerView)
        NSLayoutConstraint.activate([
            checkmarkContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            checkmarkContainerView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.CHECKMARK_CONTAINER_VIEW_TOP_MARGIN),
            checkmarkContainerView.widthAnchor.constraint(equalToConstant: Constants.CHECKMARK_CONTAINER_VIEW_SIZE),
            checkmarkContainerView.heightAnchor.constraint(equalToConstant: Constants.CHECKMARK_CONTAINER_VIEW_SIZE)
        ])
        
        let checkmarkImageView = UIImageView(image: UIImage(imageLiteralResourceName: "check"))
        checkmarkImageView.tintColor = .bitcoinGreen
        checkmarkImageView.contentMode = .scaleAspectFit
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkContainerView.addSubview(checkmarkImageView)
        NSLayoutConstraint.activate([
            checkmarkImageView.centerXAnchor.constraint(equalTo: checkmarkContainerView.centerXAnchor),
            checkmarkImageView.centerYAnchor.constraint(equalTo: checkmarkContainerView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: Constants.ICON_SIZE),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: Constants.ICON_SIZE)
        ])
    }
    
    private func setupPaymentReceivedLabel() {
        paymentReceivedLabel.textColor = .white
        paymentReceivedLabel.numberOfLines = 0
        paymentReceivedLabel.textAlignment = .center
        paymentReceivedLabel.font = .boldSystemFont(ofSize: Constants.PAYMENT_RECEIVED_FONT_SIZE)
        paymentReceivedLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(paymentReceivedLabel)
        NSLayoutConstraint.activate([
            paymentReceivedLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppConstants.GENERAL_MARGIN),
            paymentReceivedLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppConstants.GENERAL_MARGIN),
            paymentReceivedLabel.topAnchor.constraint(equalTo: checkmarkContainerView.bottomAnchor, constant: AppConstants.GENERAL_MARGIN)
        ])
    }
    
    private func setupDoneButton() {
        doneButton.titleLabel?.font = .boldSystemFont(ofSize: 16.0)
        doneButton.backgroundColor = .white
        doneButton.setTitleColor(.bitcoinGreen, for: .normal)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.layer.cornerRadius = AppConstants.GENERAL_CORNER_RADIUS
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        addSubview(doneButton)
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppConstants.GENERAL_MARGIN),
            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppConstants.GENERAL_MARGIN),
            doneButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.DONE_BUTTON_BOTTOM_MARGIN),
            doneButton.heightAnchor.constraint(equalToConstant: Constants.DONE_BUTTON_HEIGHT)
        ])
    }
    
    private func localize() {
        paymentReceivedLabel.text = Localized.paymentReceived
        doneButton.setTitle(Localized.done, for: .normal)
    }

}

private struct Localized {
    static var done: String { NSLocalizedString("button_done", comment: "") }
    static var paymentReceived: String { NSLocalizedString("payment_received", comment: "") }
}

private struct Constants {
    static let PAYMENT_RECEIVED_FONT_SIZE: CGFloat = 16.0
    static let CHECKMARK_CONTAINER_VIEW_TOP_MARGIN: CGFloat = 150.0
    static let CHECKMARK_CONTAINER_VIEW_SIZE: CGFloat = 80.0
    static let DONE_BUTTON_HEIGHT: CGFloat = 55.0
    static let DONE_BUTTON_BOTTOM_MARGIN: CGFloat = 100.0
    static let ICON_SIZE: CGFloat = 30.0
}
