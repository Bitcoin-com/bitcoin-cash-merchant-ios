//
//  PinViewController.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/20/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import UIKit

enum PinViewControllerState {
    case authorize
    case create
    case confirm
}

protocol PinViewControllerDelegate: class {
    func pinViewControllerDidEnterPinSuccessfully(_ viewController: PinViewController)
    func pinViewControllerDidCreatePinSuccessfully(_ viewController: PinViewController)
}

final class PinViewController: UIViewController {

    // MARK: - Properties
    private var verificationView = VerificationView()
    private var explanationLabel = UILabel()
    private var keypadView = KeypadView()
    private var code = ""
    private var verifyCode = ""
    var state: PinViewControllerState = .authorize
    weak var delegate: PinViewControllerDelegate?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        localize()
    }
    
    // MARK: - Private API
    private func setupView() {
        view.backgroundColor = .white
        
        setupKeypadView()
        setupVerificationView()
        setupExpalanationLabel()
    }
    
    private func setupKeypadView() {
        keypadView.backgroundColor = .white
        keypadView.translatesAutoresizingMaskIntoConstraints = false
        keypadView.delegate = self
        keypadView.isDecimalPoint = false
        view.addSubview(keypadView)
        NSLayoutConstraint.activate([
            keypadView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppConstants.GENERAL_MARGIN),
            keypadView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppConstants.GENERAL_MARGIN),
            keypadView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: Constants.KEYPAD_VIEW_CENTER_OFFSET),
            keypadView.heightAnchor.constraint(equalToConstant: 4 * KeypadView.KEYPAD_BUTTON_SIZE)
        ])
    }
    
    private func setupVerificationView() {
        verificationView.translatesAutoresizingMaskIntoConstraints = false
        verificationView.delegate = self
        view.addSubview(verificationView)
        NSLayoutConstraint.activate([
            verificationView.leadingAnchor.constraint(equalTo: keypadView.leadingAnchor, constant: Constants.VERIFICATION_VIEW_HORIZONTAL_PADDING),
            verificationView.trailingAnchor.constraint(equalTo: keypadView.trailingAnchor, constant: -Constants.VERIFICATION_VIEW_HORIZONTAL_PADDING),
            verificationView.bottomAnchor.constraint(equalTo: keypadView.topAnchor, constant: -Constants.VERIFICATION_VIEW_BOTTOM_MARGIN),
            verificationView.heightAnchor.constraint(equalToConstant: Constants.VERIFICATION_VIEW_HEIGHT)
        ])
        
        verificationView.setNumbersRequired(AppConstants.PIN_NUMBERS_REQUIRED)
    }
    
    private func setupExpalanationLabel() {
        explanationLabel.textColor = .gray
        explanationLabel.numberOfLines = 0
        explanationLabel.textAlignment = .center
        explanationLabel.translatesAutoresizingMaskIntoConstraints = false
        explanationLabel.font = .systemFont(ofSize: 16.0)
        view.addSubview(explanationLabel)
        NSLayoutConstraint.activate([
            explanationLabel.centerXAnchor.constraint(equalTo: keypadView.centerXAnchor),
            explanationLabel.topAnchor.constraint(equalTo: verificationView.bottomAnchor, constant: Constants.EXPLANATION_LABEL_TOP_MARGIN)
        ])
    }
    
    private func localize() {
        switch state {
        case .authorize:
            explanationLabel.text = Localized.enterPinCode
        case .create:
            explanationLabel.text = Localized.createPinCode
        case .confirm:
            explanationLabel.text = Localized.confirmPinCode
        }
    }
    
    private func transitionToState(_ state: PinViewControllerState) {
        self.state = state
        
        switch state {
        case .authorize:
            explanationLabel.text = Localized.enterPinCode
        case .create:
            explanationLabel.text = Localized.createPinCode
        case .confirm:
            explanationLabel.text = Localized.confirmPinCode
        }
    }
    
    private func reset() {
        code = ""
        verifyCode = ""
        verificationView.reset()
    }

}

extension PinViewController: KeypadViewDelegate {
    
    // MARK: - KeypadViewDelegate
    func keypadView(_ keypadView: KeypadView, didTapOnNumber number: Int) {
        if state == .authorize || state == .create {
            if code.length < AppConstants.PIN_NUMBERS_REQUIRED {
                code = "\(code)\(number)"
                verificationView.text = code
            }
        } else { // Confirm.
            if verifyCode.length < AppConstants.PIN_NUMBERS_REQUIRED {
                verifyCode = "\(verifyCode)\(number)"
                verificationView.text = verifyCode
            }
        }
    }
    
    func keypadViewDidTapOnDecimalPoint(_ keypadView: KeypadView) {
        
    }
    
    func keypadViewDidTapOnBackspace(_ keypadView: KeypadView) {
        if state == .authorize || state == .create {
            code = code.substring(toIndex: code.length - 1)
            verificationView.text = code
        } else { // Confirm.
            verifyCode = verifyCode.substring(toIndex: verifyCode.length - 1)
            verificationView.text = verifyCode
        }
    }
    
}

extension PinViewController: VerificationViewDelegate {
    
    // MARK: - VerificationViewDelegate
    func verificationView(_ verificationView: VerificationView, didEnterCode code: String) {
        if state == .authorize { // Authorization.
            if let pin = UserManager.shared.pin {
                if code != pin {
                    reset()
                    ToastManager.shared.showMessage(Localized.pinCodeError, forStatus: .failure)
                } else {
                    delegate?.pinViewControllerDidEnterPinSuccessfully(self)
                }
            }
        } else if state == .create { // PIN creation.
            reset()
            
            self.code = code
            transitionToState(.confirm)
        } else { // Confirm.
            if self.code == code {
                UserManager.shared.pin = code
                NotificationCenter.default.post(name: .refreshSettings, object: nil)
                delegate?.pinViewControllerDidCreatePinSuccessfully(self)
            } else {
                reset()
                transitionToState(.create)
                ToastManager.shared.showMessage(Localized.pinCodeCreateError, forStatus: .failure)
            }
        }
    }
    
}

private struct Localized {
    static var createPinCode: String { NSLocalizedString("create_pin", comment: "") }
    static var enterPinCode: String { NSLocalizedString("enter_pin", comment: "") }
    static var confirmPinCode: String { NSLocalizedString("confirm_pin", comment: "") }
    static var pinCodeError: String { NSLocalizedString("pin_code_enter_error", comment: "") }
    static var pinCodeCreateError: String { NSLocalizedString("pin_code_create_error", comment: "") }
}

private struct Constants {
    static let VERIFICATION_VIEW_BOTTOM_MARGIN: CGFloat = 100.0
    static let VERIFICATION_VIEW_HORIZONTAL_PADDING: CGFloat = 10.0
    static let VERIFICATION_VIEW_HEIGHT: CGFloat = 60.0
    static let EXPLANATION_LABEL_TOP_MARGIN: CGFloat = 20.0
    static let KEYPAD_VIEW_CENTER_OFFSET: CGFloat = 100.0
}
