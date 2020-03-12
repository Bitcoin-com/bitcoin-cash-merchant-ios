//
//  PaymentInputViewController.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/20/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import UIKit

final class PaymentInputViewController: UIViewController {

    // MARK: - Properties
    private var overlayButton = UIButton()
    private var labelsStackView = UIStackView()
    private var currencyLabel = UILabel()
    private var amountLabel = UILabel()
    private var enterAmountLabel = UILabel()
    private var keypadView = KeypadView()
    private var checkoutButton = UIButton()
    private var menuButton = UIButton()
    private var amountString = "0" {
        didSet {
            amountLabel.text = amountString
        }
    }
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.locale = UserManager.shared.selectedCurrency.locale
        
        return formatter
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        localize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let invoice = UserManager.shared.activeInvoice, invoice.isOpen {
            showInvoice(invoice)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        amountString = "0"
    }
    
    // MARK: - Public API
    func toggleOverlayButton(to option: Bool, animated: Bool = true) {
        let duration: TimeInterval = animated ? AppConstants.ANIMATION_DURATION : 0.0
        
        UIView.animate(withDuration: duration) {
            self.overlayButton.alpha = option ? Constants.OVERLAY_BUTTON_VISIBLE_ALPHA : 0.0
        }
    }
    
    // MARK: - Actions
    @objc private func checkoutButtonTapped() {
        AnalyticsService.shared.logEvent(.tapCheckout)
        
        if let amount = Double(amountString) {
            if amount == 0.0 {
                ToastManager.shared.showMessage(Localized.invalidAmount, forStatus: .failure)
            } else {
                let paymentRequestViewController = PaymentRequestViewController()
                paymentRequestViewController.amount = amount
                paymentRequestViewController.modalPresentationStyle = .fullScreen
                present(paymentRequestViewController, animated: true)
            }
        }
    }
    
    @objc private func menuButtonTapped() {
        NotificationCenter.default.post(name: .showSideMenu, object: nil)
    }
    
    // MARK: - Private API
    private func setupView() {
        view.backgroundColor = .white
        
        setupKeypadView()
        setupCheckoutButton()
        setupEnterAmountLabel()
        setupLabelsStackView()
        setupOverlayButton()
        setupMenuButton()
    }
    
    private func setupKeypadView() {
        keypadView.backgroundColor = .white
        keypadView.translatesAutoresizingMaskIntoConstraints = false
        keypadView.delegate = self
        view.addSubview(keypadView)
        NSLayoutConstraint.activate([
            keypadView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppConstants.GENERAL_MARGIN),
            keypadView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppConstants.GENERAL_MARGIN),
            keypadView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: Constants.KEYPAD_VIEW_CENTER_OFFSET),
            keypadView.heightAnchor.constraint(equalToConstant: 4 * KeypadView.KEYPAD_BUTTON_SIZE)
        ])
    }
    
    private func setupCheckoutButton() {
        checkoutButton.titleLabel?.font = .boldSystemFont(ofSize: 16.0)
        checkoutButton.backgroundColor = .bitcoinGreen
        checkoutButton.translatesAutoresizingMaskIntoConstraints = false
        checkoutButton.layer.cornerRadius = Constants.CHECKOUT_BUTTON_HEIGHT / 2
        checkoutButton.addTarget(self, action: #selector(checkoutButtonTapped), for: .touchUpInside)
        view.addSubview(checkoutButton)
        NSLayoutConstraint.activate([
            checkoutButton.leadingAnchor.constraint(equalTo: keypadView.leadingAnchor),
            checkoutButton.trailingAnchor.constraint(equalTo: keypadView.trailingAnchor),
            checkoutButton.topAnchor.constraint(equalTo: keypadView.bottomAnchor, constant: AppConstants.GENERAL_MARGIN),
            checkoutButton.heightAnchor.constraint(equalToConstant: Constants.CHECKOUT_BUTTON_HEIGHT)
        ])
    }
    
    private func setupEnterAmountLabel() {
        enterAmountLabel.textColor = .blockchainGray
        enterAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        enterAmountLabel.font = .systemFont(ofSize: 16.0)
        view.addSubview(enterAmountLabel)
        NSLayoutConstraint.activate([
            enterAmountLabel.centerXAnchor.constraint(equalTo: keypadView.centerXAnchor),
            enterAmountLabel.bottomAnchor.constraint(equalTo: keypadView.topAnchor, constant: -Constants.ENTER_AMOUNT_LABEL_BOTTOM_MARGIN)
        ])
    }
    
    private func setupLabelsStackView() {
        currencyLabel.textColor = .black
        currencyLabel.font = .boldSystemFont(ofSize: Constants.AMOUNT_FONT_SIZE)
        
        amountLabel.textColor = .black
        amountLabel.font = .boldSystemFont(ofSize: Constants.AMOUNT_FONT_SIZE)
        
        labelsStackView.addArrangedSubview(currencyLabel)
        labelsStackView.addArrangedSubview(amountLabel)
        labelsStackView.alignment = .center
        labelsStackView.axis = .horizontal
        labelsStackView.distribution = .fillProportionally
        labelsStackView.spacing = Constants.LABELS_STACK_VIEW_SPACING
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelsStackView)
        NSLayoutConstraint.activate([
            labelsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: enterAmountLabel.topAnchor, constant: -Constants.LABELS_STACK_VIEW_BOTTOM_MARGIN)
        ])
    }
    
    private func setupMenuButton() {
        menuButton.setImage(UIImage(imageLiteralResourceName: "menu"), for: .normal)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        menuButton.tintColor = .black
        view.addSubview(menuButton)
        NSLayoutConstraint.activate([
            menuButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.MENU_BUTTON_MARGIN),
            menuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.MENU_BUTTON_MARGIN / 2),
            menuButton.heightAnchor.constraint(equalToConstant: Constants.MENU_BUTTON_SIZE),
            menuButton.widthAnchor.constraint(equalToConstant: Constants.MENU_BUTTON_SIZE)
        ])
    }
    
    private func setupOverlayButton() {
        overlayButton.alpha = 0.0
        overlayButton.backgroundColor = .black
        overlayButton.translatesAutoresizingMaskIntoConstraints = false
        overlayButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        view.addSubview(overlayButton)
        NSLayoutConstraint.activate([
            overlayButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayButton.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    
    private func localize() {
        checkoutButton.setTitle(Localized.checkout, for: .normal)
        enterAmountLabel.text = Localized.enterAmount
        currencyLabel.text = numberFormatter.currencySymbol
        amountLabel.text = amountString
    }
    
    private func showInvoice(_ invoice: InvoiceStatus) {
        let paymentRequestViewController = PaymentRequestViewController()
        paymentRequestViewController.invoice = invoice
        paymentRequestViewController.modalPresentationStyle = .fullScreen
        present(paymentRequestViewController, animated: true)
    }

}

extension PaymentInputViewController: KeypadViewDelegate {
    
    // MARK: - KeypadViewDelegate
    func keypadView(_ keypadView: KeypadView, didTapOnNumber number: Int) {
        if amountString.count >= Constants.MAX_ALLOWED_NUMBER_OF_DIGITS { return }
        
        if amountString == "0" {
            amountString = "\(number)"
        } else {
            amountString = "\(amountString)\(number)"
        }
    }
    
    func keypadViewDidTapOnDecimalPoint(_ keypadView: KeypadView) {
        if amountString.count >= Constants.MAX_ALLOWED_NUMBER_OF_DIGITS { return }
        if amountString.contains(".") { return }
        
        amountString = "\(amountString)."
    }
    
    func keypadViewDidTapOnBackspace(_ keypadView: KeypadView) {
        if amountString.count > 1 {
            amountString = amountString.substring(toIndex: amountString.length - 1)
        } else {
            amountString = "0"
        }
    }
    
}

private struct Localized {
    static var checkout: String { NSLocalizedString("confirm_request", comment: "") }
    static var enterAmount: String { NSLocalizedString("payment_enter_an_amount", comment: "") }
    static var invalidAmount: String { NSLocalizedString("invalid_amount", comment: "") }
}

private struct Constants {
    static let AMOUNT_FONT_SIZE: CGFloat = 60.0
    static let ENTER_AMOUNT_LABEL_BOTTOM_MARGIN: CGFloat = 20.0
    static let LABELS_STACK_VIEW_SPACING: CGFloat = 5.0
    static let LABELS_STACK_VIEW_BOTTOM_MARGIN: CGFloat = 10.0
    static let CHECKOUT_BUTTON_HEIGHT: CGFloat = 55.0
    static let MENU_BUTTON_SIZE: CGFloat = 44.0
    static let MENU_BUTTON_MARGIN: CGFloat = 20.0
    static let OVERLAY_BUTTON_VISIBLE_ALPHA: CGFloat = 0.7
    static let MAX_ALLOWED_NUMBER_OF_DIGITS = 12
    static let KEYPAD_VIEW_CENTER_OFFSET: CGFloat = 50.0
}
