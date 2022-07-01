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
        formatter.minimumFractionDigits = UserManager.shared.selectedCurrency.decimals
        formatter.maximumFractionDigits = UserManager.shared.selectedCurrency.decimals
        formatter.locale = UserManager.shared.selectedCurrency.locale
        
        return formatter
    }
    
    // MARK: - Layout Properties
    private var constraints : [NSLayoutConstraint] = [];
    
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
        
        if let invoice = UserManager.shared.activeInvoice, invoice.isOpen, !invoice.isTimerExpired {
            showInvoice(invoice)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        amountString = "0"
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { [self] (context) in
            setupConstraints()
        })
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
        AnalyticsService.shared.logEvent(.invoice_checkout)
        let outdated = RateManager.shared.isSeverelyOutdated()
        if outdated == true {
            RateManager.shared.fetchRate()
            ToastManager.shared.showMessage(Localized.outdatedRates, forStatus: .failure)
            return
        }
        
        if let amount = Double(amountString) {
            if amount == 0.0 {
                ToastManager.shared.showMessage(Localized.invalidAmount, forStatus: .failure)
            } else {
                if isConnectedToNetwork {
                    let paymentRequestViewController = PaymentRequestViewController()
                    paymentRequestViewController.amount = amount
                    paymentRequestViewController.modalPresentationStyle = .fullScreen
                    present(paymentRequestViewController, animated: true)
                } else {
                    showRetryDialog()
                }
            }
        }
    }
    
    @objc private func menuButtonTapped() {
        NotificationCenter.default.post(name: .showSideMenu, object: nil)
    }
    
    @objc private func updateCurrency() {
        keypadView.hasDecimalPoint = UserManager.shared.selectedCurrency.decimals > 0
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
        registerForNotifications()
        setupConstraints()
    }
    
    private func setupKeypadView() {
        keypadView.accessibilityIdentifier = Tests.PaymentInput.keypadView
        updateCurrency()
        keypadView.delegate = self
        keypadView.backgroundColor = .white
        keypadView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keypadView)
    }
    
    private func setupCheckoutButton() {
        checkoutButton.accessibilityIdentifier = Tests.PaymentInput.checkoutButton
        checkoutButton.titleLabel?.font = .boldSystemFont(ofSize: 16.0)
        checkoutButton.backgroundColor = .bitcoinGreen
        checkoutButton.translatesAutoresizingMaskIntoConstraints = false
        checkoutButton.layer.cornerRadius = Constants.CHECKOUT_BUTTON_HEIGHT / 2
        checkoutButton.addTarget(self, action: #selector(checkoutButtonTapped), for: .touchUpInside)
        view.addSubview(checkoutButton)
    }
    
    private func setupEnterAmountLabel() {
        enterAmountLabel.textColor = .blockchainGray
        enterAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        enterAmountLabel.font = .systemFont(ofSize: 16.0)
        view.addSubview(enterAmountLabel)
    }
    
    private func setupLabelsStackView() {
        currencyLabel.textColor = .black
        currencyLabel.font = .systemFont(ofSize: Constants.AMOUNT_FONT_SIZE)
        
        amountLabel.accessibilityIdentifier = Tests.PaymentInput.amountLabel
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
    }
    
    private func setupMenuButton() {
        menuButton.accessibilityIdentifier = Tests.PaymentInput.menuButton
        menuButton.setImage(UIImage(imageLiteralResourceName: "menu"), for: .normal)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        menuButton.tintColor = .black
        view.addSubview(menuButton)
    }
    
    private func setupOverlayButton() {
        overlayButton.alpha = 0.0
        overlayButton.backgroundColor = .black
        overlayButton.translatesAutoresizingMaskIntoConstraints = false
        overlayButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        view.addSubview(overlayButton)
    }
    
    
    private func setupConstraints() {
        NSLayoutConstraint.deactivate(constraints)
        
        constraints = [
            checkoutButton.leadingAnchor.constraint(equalTo: keypadView.leadingAnchor),
            checkoutButton.trailingAnchor.constraint(equalTo: keypadView.trailingAnchor),
            checkoutButton.topAnchor.constraint(equalTo: keypadView.bottomAnchor, constant: AppConstants.GENERAL_MARGIN),
            checkoutButton.heightAnchor.constraint(equalToConstant: Constants.CHECKOUT_BUTTON_HEIGHT),
            
            enterAmountLabel.centerXAnchor.constraint(equalTo: keypadView.centerXAnchor),
            enterAmountLabel.bottomAnchor.constraint(equalTo: keypadView.topAnchor, constant: -Constants.ENTER_AMOUNT_LABEL_BOTTOM_MARGIN),
            
            labelsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: enterAmountLabel.topAnchor, constant: -Constants.LABELS_STACK_VIEW_BOTTOM_MARGIN),
            
            menuButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.MENU_BUTTON_MARGIN),
            menuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.MENU_BUTTON_MARGIN / 2),
            menuButton.heightAnchor.constraint(equalToConstant: Constants.MENU_BUTTON_SIZE),
            menuButton.widthAnchor.constraint(equalToConstant: Constants.MENU_BUTTON_SIZE),
            
            overlayButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayButton.topAnchor.constraint(equalTo: view.topAnchor),
        ]
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        let keypadButtonSize : CGFloat
        let keypadViewCenterOffset : CGFloat
        
        var keypadMargin = Constants.KEYPAD_VIEW_MARGIN
        if(screenWidth >= 600) {
            keypadMargin = 164.0
        }
        
        if windowInterfaceOrientation?.isLandscape ?? false {
            keypadMargin = 256.0
            keypadButtonSize = screenHeight / 5 * 3
            keypadViewCenterOffset = Constants.KEYPAD_VIEW_CENTER_OFFSET_LANDSCAPE
        } else {
            keypadButtonSize = screenWidth / 5 * 4
            keypadViewCenterOffset = Constants.KEYPAD_VIEW_CENTER_OFFSET_PORTRAIT
        }
        
        constraints.append(contentsOf: [
            keypadView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: keypadMargin),
            keypadView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -keypadMargin),
            keypadView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: keypadViewCenterOffset),
            keypadView.heightAnchor.constraint(equalToConstant: keypadButtonSize)
        ])
        
        NSLayoutConstraint.activate(constraints)
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
    
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateCurrency), name: .currencyUpdated, object: nil)
    }
    
    private func showRetryDialog() {
        let alertController = UIAlertController(title: Localized.error, message: Localized.noNetworkConnection, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: Localized.cancel, style: .cancel)
        alertController.addAction(cancelAction)
        
        let retryAction = UIAlertAction(title: Localized.retry, style: .default) { [weak self] _ in
            self?.checkoutButtonTapped()
        }
        alertController.addAction(retryAction)
        
        present(alertController, animated: true)
    }

}

extension PaymentInputViewController: KeypadViewDelegate {
    
    // MARK: - KeypadViewDelegate
    func keypadView(_ keypadView: KeypadView, didTapOnNumber number: Int) {
        if amountString.count >= Constants.MAX_ALLOWED_NUMBER_OF_DIGITS { return }
        
        if amountString == "0" {
            amountString = "\(number)"
        } else {
            if let index = amountString.firstIndex(of: ".")?.utf16Offset(in: amountString) {
                let decimalPart = amountString.substring(fromIndex: index)
                
                if decimalPart.length > UserManager.shared.selectedCurrency.decimals { return }
            }
            
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
    static var outdatedRates: String { NSLocalizedString("outdated_rates", comment: "") }
    static var checkout: String { NSLocalizedString("confirm_request", comment: "") }
    static var enterAmount: String { NSLocalizedString("payment_enter_an_amount", comment: "") }
    static var invalidAmount: String { NSLocalizedString("invalid_amount", comment: "") }
    static var noNetworkConnection: String { NSLocalizedString("error_check_your_network_connection", comment: "") }
    static var retry: String { NSLocalizedString("retry", comment: "") }
    static var cancel: String { NSLocalizedString("button_cancel", comment: "") }
    static var error: String { NSLocalizedString("error", comment: "") }
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
    static let KEYPAD_VIEW_CENTER_OFFSET_PORTRAIT: CGFloat = 50.0
    static let KEYPAD_VIEW_CENTER_OFFSET_LANDSCAPE: CGFloat = 32.0
    static let KEYPAD_VIEW_MARGIN: CGFloat = 35.0
}
