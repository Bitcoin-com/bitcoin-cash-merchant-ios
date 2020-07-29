//
//  SettingsViewController.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/20/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import UIKit
import BitcoinKit

final class SettingsViewController: UIViewController {

    // MARK: - Properties
    private let topOverlayView = GradientView(colors: [.white, .white, UIColor.white.withAlphaComponent(0)])
    private var navigationBar = NavigationBar()
    private var scrollView = UIScrollView()
    private var itemsView = ItemsView()
    private var walletAdView = UIView()
    private var walletLabel = UILabel()
    private var localBitcoinCashAdView = UIView()
    private var localBitcoinCashLabel = UILabel()
    private var exchangeAdView = UIView()
    private var exchangeLabel = UILabel()
    private var itemsViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        localize()
        registerForNotifications()
    }
    
    // MARK: - Actions
    @objc private func walletAdViewTapped() {
        AnalyticsService.shared.logEvent(.tap_link_wallet)
        
        openLinkInSafari(link: Endpoints.bitcoinWalletAppStore)
    }
    
    @objc private func localBitcoinCashAdViewTapped() {
        AnalyticsService.shared.logEvent(.tap_link_localbitcoin)
        
        openLinkInSafari(link: Endpoints.localBitcoin)
    }
    
    @objc private func exchangeAdViewTapped() {
        AnalyticsService.shared.logEvent(.tap_link_exchange)
        
        openLinkInSafari(link: Endpoints.exchangeBitcoin)
    }
    
    @objc private func refresh() {
        itemsView.refresh()
    }
    
    // MARK: - Private API
    private func setupView() {
        view.backgroundColor = .white
        
        setupTopOverlayView()
        setupNavigationBar()
        setupScrollView()
        setupItemsView()
        setupWalletAdView()
        setupLocalBitcoinCashAdView()
        setupExchangeAdView()
        updateScrollViewContentSize()
        
        view.bringSubviewToFront(topOverlayView)
        view.bringSubviewToFront(navigationBar)
    }
    
    private func setupTopOverlayView() {
        topOverlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topOverlayView)
        NSLayoutConstraint.activate([
            topOverlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topOverlayView.topAnchor.constraint(equalTo: view.topAnchor),
            topOverlayView.heightAnchor.constraint(equalToConstant: Constants.TOP_OVERLAY_VIEW_HEIGHT)
        ])
    }
    
    private func setupNavigationBar() {
        navigationBar.accessibilityIdentifier = Tests.NavigationBar.identifier
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.onClose = { [weak self] in
            if UserManager.shared.hasDestinationAddress {
                self?.navigationController?.popViewController(animated: true)
            } else {
                self?.showWarningAboutMissingBCHAddress()
            }
        }
        view.addSubview(navigationBar)
        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: NavigationBar.height)
        ])
    }
    
    private func setupScrollView() {
        scrollView.clipsToBounds = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalToConstant: Constants.SCROLL_VIEW_WIDTH)
        ])
    }
    
    private func setupItemsView() {
        itemsView.accessibilityIdentifier = Tests.Settings.itemsView
        itemsView.items = [
            UserItem.merchantName,
            UserItem.destinationAddress,
            UserItem.localCurrency,
            UserItem.pin
        ]
        itemsView.delegate = self
        itemsView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(itemsView)
        
        itemsViewHeightConstraint = itemsView.heightAnchor.constraint(equalToConstant: itemsView.height)
        
        NSLayoutConstraint.activate([
            itemsView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            itemsView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            itemsView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            itemsViewHeightConstraint!
        ])
    }
    
    private func setupWalletAdView() {
        walletAdView.accessibilityIdentifier = Tests.Settings.walletAdView
        walletAdView.translatesAutoresizingMaskIntoConstraints = false
        walletAdView.isUserInteractionEnabled = true
        scrollView.addSubview(walletAdView)
        NSLayoutConstraint.activate([
            walletAdView.leadingAnchor.constraint(equalTo: itemsView.leadingAnchor, constant: Constants.AD_HORIZONTAL_PADDING),
            walletAdView.trailingAnchor.constraint(equalTo: itemsView.trailingAnchor, constant: -Constants.AD_HORIZONTAL_PADDING),
            walletAdView.topAnchor.constraint(equalTo: itemsView.bottomAnchor, constant: Constants.AD_TOP_MARGIN),
            walletAdView.heightAnchor.constraint(equalToConstant: Constants.AD_HEIGHT)
        ])
        
        // Tap Gesture.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(walletAdViewTapped))
        walletAdView.addGestureRecognizer(tapGestureRecognizer)
        
        // Banner.
        let bannerImageView = UIImageView(image: UIImage(imageLiteralResourceName: "wallet_banner"))
        bannerImageView.translatesAutoresizingMaskIntoConstraints = false
        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.clipsToBounds = true
        walletAdView.addSubview(bannerImageView)
        NSLayoutConstraint.activate([
            bannerImageView.leadingAnchor.constraint(equalTo: walletAdView.leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: walletAdView.trailingAnchor),
            bannerImageView.topAnchor.constraint(equalTo: walletAdView.topAnchor),
            bannerImageView.bottomAnchor.constraint(equalTo: walletAdView.bottomAnchor)
        ])
        
        // Logo.
        let logoImageView = UIImageView(image: UIImage(imageLiteralResourceName: "wallet"))
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.clipsToBounds = true
        walletAdView.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: walletAdView.leadingAnchor, constant: Constants.LOGO_LEADING_MARGIN),
            logoImageView.topAnchor.constraint(equalTo: walletAdView.topAnchor, constant: Constants.LOGO_TOP_MARGIN),
            logoImageView.widthAnchor.constraint(equalToConstant: Constants.LOGO_WIDTH),
            logoImageView.heightAnchor.constraint(equalToConstant: Constants.LOGO_HEIGHT)
        ])
        
        setupWalletLabel()
    }
    
    private func setupWalletLabel() {
        walletLabel.textColor = .white
        walletLabel.numberOfLines = 0
        walletLabel.textAlignment = .left
        walletLabel.adjustsFontSizeToFitWidth = true
        walletLabel.translatesAutoresizingMaskIntoConstraints = false
        walletAdView.addSubview(walletLabel)
        NSLayoutConstraint.activate([
            walletLabel.leadingAnchor.constraint(equalTo: walletAdView.leadingAnchor, constant: Constants.LOGO_LEADING_MARGIN),
            walletLabel.topAnchor.constraint(equalTo: walletAdView.topAnchor, constant: Constants.LABEL_TOP_MARGIN),
            walletLabel.bottomAnchor.constraint(equalTo: walletAdView.bottomAnchor, constant: -Constants.LOGO_TOP_MARGIN),
            walletLabel.widthAnchor.constraint(equalToConstant: Constants.LABEL_WIDTH)
        ])
    }
    
    private func setupLocalBitcoinCashAdView() {
        localBitcoinCashAdView.accessibilityIdentifier = Tests.Settings.localBitcoinCashAdView
        localBitcoinCashAdView.translatesAutoresizingMaskIntoConstraints = false
        localBitcoinCashAdView.isUserInteractionEnabled = true
        scrollView.addSubview(localBitcoinCashAdView)
        NSLayoutConstraint.activate([
            localBitcoinCashAdView.leadingAnchor.constraint(equalTo: itemsView.leadingAnchor, constant: Constants.AD_HORIZONTAL_PADDING),
            localBitcoinCashAdView.trailingAnchor.constraint(equalTo: itemsView.trailingAnchor, constant: -Constants.AD_HORIZONTAL_PADDING),
            localBitcoinCashAdView.topAnchor.constraint(equalTo: walletAdView.bottomAnchor, constant: Constants.AD_TOP_MARGIN),
            localBitcoinCashAdView.heightAnchor.constraint(equalToConstant: Constants.AD_HEIGHT)
        ])
        
        // Tap Gesture.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(localBitcoinCashAdViewTapped))
        localBitcoinCashAdView.addGestureRecognizer(tapGestureRecognizer)
        
        // Banner.
        let bannerImageView = UIImageView(image: UIImage(imageLiteralResourceName: "localbch_banner"))
        bannerImageView.translatesAutoresizingMaskIntoConstraints = false
        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.clipsToBounds = true
        localBitcoinCashAdView.addSubview(bannerImageView)
        NSLayoutConstraint.activate([
            bannerImageView.leadingAnchor.constraint(equalTo: localBitcoinCashAdView.leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: localBitcoinCashAdView.trailingAnchor),
            bannerImageView.topAnchor.constraint(equalTo: localBitcoinCashAdView.topAnchor),
            bannerImageView.bottomAnchor.constraint(equalTo: localBitcoinCashAdView.bottomAnchor)
        ])
        
        // Logo.
        let logoImageView = UIImageView(image: UIImage(imageLiteralResourceName: "local"))
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.clipsToBounds = true
        localBitcoinCashAdView.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: localBitcoinCashAdView.leadingAnchor, constant: Constants.LOGO_LEADING_MARGIN),
            logoImageView.topAnchor.constraint(equalTo: localBitcoinCashAdView.topAnchor, constant: Constants.LOGO_TOP_MARGIN),
            logoImageView.widthAnchor.constraint(equalToConstant: Constants.LOGO_WIDTH),
            logoImageView.heightAnchor.constraint(equalToConstant: Constants.LOGO_HEIGHT)
        ])
        
        setupLocalBitcoinCashLabel()
    }
    
    private func setupLocalBitcoinCashLabel() {
        localBitcoinCashLabel.textColor = .white
        localBitcoinCashLabel.numberOfLines = 0
        localBitcoinCashLabel.textAlignment = .left
        localBitcoinCashLabel.adjustsFontSizeToFitWidth = true
        localBitcoinCashLabel.translatesAutoresizingMaskIntoConstraints = false
        localBitcoinCashAdView.addSubview(localBitcoinCashLabel)
        NSLayoutConstraint.activate([
            localBitcoinCashLabel.leadingAnchor.constraint(equalTo: localBitcoinCashAdView.leadingAnchor, constant: Constants.LOGO_LEADING_MARGIN),
            localBitcoinCashLabel.topAnchor.constraint(equalTo: localBitcoinCashAdView.topAnchor, constant: Constants.LABEL_TOP_MARGIN),
            localBitcoinCashLabel.bottomAnchor.constraint(equalTo: localBitcoinCashAdView.bottomAnchor, constant: -Constants.LOGO_TOP_MARGIN),
            localBitcoinCashLabel.widthAnchor.constraint(equalToConstant: Constants.LABEL_WIDTH)
        ])
    }
    
    private func setupExchangeAdView() {
        exchangeAdView.accessibilityIdentifier = Tests.Settings.exchangeAdView
        exchangeAdView.translatesAutoresizingMaskIntoConstraints = false
        exchangeAdView.isUserInteractionEnabled = true
        scrollView.addSubview(exchangeAdView)
        NSLayoutConstraint.activate([
            exchangeAdView.leadingAnchor.constraint(equalTo: itemsView.leadingAnchor, constant: Constants.AD_HORIZONTAL_PADDING),
            exchangeAdView.trailingAnchor.constraint(equalTo: itemsView.trailingAnchor, constant: -Constants.AD_HORIZONTAL_PADDING),
            exchangeAdView.topAnchor.constraint(equalTo: localBitcoinCashAdView.bottomAnchor, constant: Constants.AD_TOP_MARGIN),
            exchangeAdView.heightAnchor.constraint(equalToConstant: Constants.AD_HEIGHT)
        ])
        
        // Tap Gesture.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(exchangeAdViewTapped))
        exchangeAdView.addGestureRecognizer(tapGestureRecognizer)
        
        // Banner.
        let bannerImageView = UIImageView(image: UIImage(imageLiteralResourceName: "bce_banner"))
        bannerImageView.translatesAutoresizingMaskIntoConstraints = false
        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.clipsToBounds = true
        exchangeAdView.addSubview(bannerImageView)
        NSLayoutConstraint.activate([
            bannerImageView.leadingAnchor.constraint(equalTo: exchangeAdView.leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: exchangeAdView.trailingAnchor),
            bannerImageView.topAnchor.constraint(equalTo: exchangeAdView.topAnchor),
            bannerImageView.bottomAnchor.constraint(equalTo: exchangeAdView.bottomAnchor)
        ])
        
        // Logo.
        let logoImageView = UIImageView(image: UIImage(imageLiteralResourceName: "exchange"))
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.clipsToBounds = true
        exchangeAdView.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: exchangeAdView.leadingAnchor, constant: Constants.LOGO_LEADING_MARGIN),
            logoImageView.topAnchor.constraint(equalTo: exchangeAdView.topAnchor, constant: Constants.LOGO_TOP_MARGIN),
            logoImageView.widthAnchor.constraint(equalToConstant: Constants.LOGO_WIDTH),
            logoImageView.heightAnchor.constraint(equalToConstant: Constants.LOGO_HEIGHT)
        ])
        
        setupExchangeLabel()
    }
    
    private func setupExchangeLabel() {
        exchangeLabel.textColor = .white
        exchangeLabel.numberOfLines = 0
        exchangeLabel.textAlignment = .left
        exchangeLabel.adjustsFontSizeToFitWidth = true
        exchangeLabel.translatesAutoresizingMaskIntoConstraints = false
        exchangeAdView.addSubview(exchangeLabel)
        NSLayoutConstraint.activate([
            exchangeLabel.leadingAnchor.constraint(equalTo: exchangeAdView.leadingAnchor, constant: Constants.LOGO_LEADING_MARGIN),
            exchangeLabel.topAnchor.constraint(equalTo: exchangeAdView.topAnchor, constant: Constants.LABEL_TOP_MARGIN),
            exchangeLabel.bottomAnchor.constraint(equalTo: exchangeAdView.bottomAnchor, constant: -Constants.LOGO_TOP_MARGIN),
            exchangeLabel.widthAnchor.constraint(equalToConstant: Constants.LABEL_WIDTH)
        ])
    }
    
    private func updateScrollViewContentSize() {
        var height = itemsView.height
        height += 4 * Constants.AD_TOP_MARGIN
        height += 3 * Constants.AD_HEIGHT
        
        scrollView.contentSize = CGSize(width: Constants.SCROLL_VIEW_WIDTH, height: height)
    }
    
    private func localize() {
        navigationBar.text = Localized.settings
        
        // Wallet.
        let walletAdAttributedString = Builder(text: Localized.adContentBitcoinWallet)
            .addAttribute(key: .font, object: UIFont.custom(style: .bold, size: 16.0))
            .create()
        walletLabel.attributedText = walletAdAttributedString
        
        // Local Bitcoin Cash.
        let localBitconCashAdAttributedString = Builder(text: Localized.adContentLocalBitcoinCash)
            .addAttribute(key: .font, object: UIFont.custom(style: .bold, size: 16.0))
            .create()
        localBitcoinCashLabel.attributedText = localBitconCashAdAttributedString
        
        // Exchange.
        let exchangeAdAttributedString = Builder(text: Localized.adContentBitcoinExchange)
            .addAttribute(key: .font, object: UIFont.custom(style: .bold, size: 16.0))
            .create()
        exchangeLabel.attributedText = exchangeAdAttributedString
    }
    
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .refreshSettings, object: nil)
    }
    
    private func updateMerchantName() {
        let alertController = UIAlertController(title: UserItem.merchantName.title, message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: Localized.cancel, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: Localized.OK, style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            if let textField = alertController.textFields?.first {
                if let text = textField.text {
                    // If the merchant name is the same as the one which is already stored - do not store it again.
                    if let storedMerchantName = UserManager.shared.companyName {
                        if text == storedMerchantName {
                            return
                        }
                    }
                    
                    AnalyticsService.shared.logEvent(.settings_merchantname_changed)
                    
                    UserManager.shared.companyName = text
                    self.refreshAndShowSuccessMessage()
                    alertController.dismiss(animated: true)
                }
            }
        }
        alertController.addAction(okAction)
        
        alertController.addTextField { textField in
            textField.text = UserManager.shared.companyName
        }
        
        present(alertController, animated: true)
    }
    
    private func showAddDestionationAddressAlert() {
        let alertController = UIAlertController(title: Localized.addDestinationAddress, message: Localized.destinationAddressExplanation, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: Localized.cancel, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let scanAction = UIAlertAction(title: Localized.scan, style: .default) { [weak self] _ in
            self?.scanQR()
        }
        alertController.addAction(scanAction)
        
        let pasteAction = UIAlertAction(title: Localized.paste, style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            if let address = UIPasteboard.general.string {
                Logger.log(message: "Pasted BCH address: \(address)", type: .info)
                
                self.validateAndStoreAddress(address)
            } else {
                self.showFailureMessage()
            }
        }
        alertController.addAction(pasteAction)
        
        present(alertController, animated: true)
    }
    
    private func validateAndStoreAddress(_ address: String) {
        let paymentTarget = PaymentTarget(target: address, type: .address)
        
        // If the address is the same as the one which is already stored - do not store it again.
        if let storedPaymentTarget = UserManager.shared.activePaymentTarget {
            if paymentTarget.legacyAddress == storedPaymentTarget.legacyAddress {
                return
            }
        }
        
        if paymentTarget.type == .invalid {
            showFailureMessage()
        } else {
            performAnalytics(for: paymentTarget)
            
            UserManager.shared.destination = paymentTarget.legacyAddress
            UserManager.shared.activePaymentTarget = paymentTarget
            refreshAndShowSuccessMessage()
        }
    }
    
    private func createPin() {
        let pinViewController = PinViewController()
        pinViewController.state = .create
        pinViewController.delegate = self
        pinViewController.modalPresentationStyle = .fullScreen
        present(pinViewController, animated: true)
    }
    
    private func scanQR() {
        let scannerViewController = ScannerViewController()
        scannerViewController.delegate = self
        scannerViewController.modalPresentationStyle = .fullScreen
        present(scannerViewController, animated: true)
    }
    
    private func pickCurrency() {
        let currenciesViewController = CurrenciesViewController()
        currenciesViewController.delegate = self
        currenciesViewController.modalPresentationStyle = .overCurrentContext
        currenciesViewController.modalTransitionStyle = .crossDissolve
        present(currenciesViewController, animated: true)
    }
    
    private func refreshAndShowSuccessMessage() {
        refreshItemsView()
        updateScrollViewContentSize()
        
        ToastManager.shared.showMessage(Localized.changesHaveBeenSaved, forStatus: .success)
        
        NotificationCenter.default.post(name: .settingsUpdated, object: nil)
    }
    
    private func refreshItemsView() {
        itemsView.refresh()
        itemsViewHeightConstraint?.constant = itemsView.height
        view.layoutIfNeeded()
    }
    
    private func showFailureMessage() {
        ToastManager.shared.showMessage(Localized.unrecognizedPublicKeyFormat, forStatus: .failure)
    }
    
    private func showWarningAboutMissingBCHAddress() {
        let alertController = UIAlertController(title: Localized.paymentAddress, message: Localized.youMustProvideBCHAddress, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: Localized.OK, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
   
    private func performAnalytics(for paymentTarget: PaymentTarget) {
        AnalyticsService.shared.logEvent(.settings_paymenttarget_changed)
        
        switch paymentTarget.type {
        case .address:
            AnalyticsService.shared.logEvent(.settings_paymenttarget_pubkey_set)
        default:
            return
        }
    }

}

extension SettingsViewController: ItemsViewDelegate {
    
    // MARK: - ItemsViewDelegate
    func itemsView(_ itemsView: ItemsView, didTapOnItem item: Item) {
        if item.title == UserItem.pin.title { // Create PIN.
            AnalyticsService.shared.logEvent(.settings_pin_edit)
            
            createPin()
        }
        
        if item.title == UserItem.merchantName.title { // Update Merchant name.
            AnalyticsService.shared.logEvent(.settings_merchantname_edit)
            
            updateMerchantName()
        }
        
        if item.title == UserItem.destinationAddress.title { // Destination address.
            AnalyticsService.shared.logEvent(.settings_paymenttarget_edit)
            
            showAddDestionationAddressAlert()
        }
        
        if item.title == UserItem.localCurrency.title { // Local Currency.
            AnalyticsService.shared.logEvent(.settings_currency_edit)
            
            pickCurrency()
        }
    }
    
}

extension SettingsViewController: PinViewControllerDelegate {
    
    // MARK: - PinViewControllerDelegate
    func pinViewControllerDidEnterPinSuccessfully(_ viewController: PinViewController) {}
    
    func pinViewController(_ viewController: PinViewController, didCreatePinSuccessfully pin: String) {
        viewController.dismiss(animated: true) { [weak self] in
            // If the pin is the same as the one which is already stored - do not store it again.
            if let storedPin = UserManager.shared.pin {
                if pin == storedPin {
                    return
                }
            }
            
            UserManager.shared.pin = pin
            
            AnalyticsService.shared.logEvent(.settings_pin_changed)
            
            self?.refreshAndShowSuccessMessage()
        }
    }
    
    func pinViewControllerDidClose(_ viewController: PinViewController) {
        viewController.dismiss(animated: true)
    }
    
}

extension SettingsViewController: ScannerViewControllerDelegate {
    
    // MARK: - ScannerViewControllerDelegate
    func scannerViewController(_ viewController: ScannerViewController, didScanStringValue stringValue: String) {
        viewController.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            
            Logger.log(message: "Scanned BCH address: \(stringValue)", type: .info)
            
            self.validateAndStoreAddress(stringValue)
        }
    }
    
}

extension SettingsViewController: CurrenciesViewControllerDelegate {
    
    // MARK: - CurrenciesViewControllerDelegate
    func currenciesViewController(_ viewController: CurrenciesViewController, didPickCurrency currency: CountryCurrency) {
        viewController.dismiss(animated: true) { [weak self] in
            if UserManager.shared.selectedCurrency == currency { return }
            
            AnalyticsService.shared.logEvent(.settings_currency_changed)
            
            UserManager.shared.selectedCurrency = currency
            self?.refreshAndShowSuccessMessage()
        }
    }
    
}

private struct Constants {
    static let TOP_OVERLAY_VIEW_HEIGHT: CGFloat = 100.0
    static let ITEMS_VIEW_MARGIN: CGFloat = 35.0
    static let LOGO_TOP_MARGIN: CGFloat = 10.0
    static let LOGO_LEADING_MARGIN: CGFloat = 20.0
    static let LOGO_WIDTH: CGFloat = 120.0
    static let LOGO_HEIGHT: CGFloat = 30.0
    static let AD_TOP_MARGIN: CGFloat = 25.0
    static let AD_HORIZONTAL_PADDING: CGFloat = 10.0
    static let AD_HEIGHT: CGFloat = 100.0
    static let LABEL_TOP_MARGIN: CGFloat = 40.0
    static let LABEL_WIDTH: CGFloat = UIScreen.main.bounds.size.width / 2 - Constants.LOGO_LEADING_MARGIN - Constants.ITEMS_VIEW_MARGIN
    static let SCROLL_VIEW_WIDTH: CGFloat = UIScreen.main.bounds.size.width - 2 * AppConstants.GENERAL_MARGIN
}

private struct Localized {
    static var settings: String { NSLocalizedString("menu_settings", comment: "") }
    static var cancel: String { NSLocalizedString("button_cancel", comment: "") }
    static var OK: String { NSLocalizedString("prompt_ok", comment: "") }
    static var addDestinationAddress: String { NSLocalizedString("options_add_payment_address", comment: "") }
    static var destinationAddressExplanation: String { NSLocalizedString("options_explain_payment_address", comment: "") }
    static var scan: String { NSLocalizedString("scan", comment: "") }
    static var paste: String { NSLocalizedString("paste", comment: "") }
    static var unrecognizedPublicKeyFormat: String { NSLocalizedString("unrecognized_xpub", comment: "") }
    static var changesHaveBeenSaved: String { NSLocalizedString("notify_changes_have_been_saved", comment: "") }
    static var paymentAddress: String { NSLocalizedString("options_payment_address", comment: "") }
    static var youMustProvideBCHAddress: String { NSLocalizedString("obligatory_receiver", comment: "") }
    static var syncingXPub: String { NSLocalizedString("syncing_xpub", comment: "") }
    static var syncedXPub: String { NSLocalizedString("synced_xpub", comment: "") }
    static var adContentBitcoinWallet: String { NSLocalizedString("ad_content_bitcoincom_wallet", comment: "") }
    static var adContentLocalBitcoinCash: String { NSLocalizedString("ad_content_local_bitcoin_cash", comment: "") }
    static var adContentBitcoinExchange: String { NSLocalizedString("ad_content_bitcoincom_exchange", comment: "") }
}
