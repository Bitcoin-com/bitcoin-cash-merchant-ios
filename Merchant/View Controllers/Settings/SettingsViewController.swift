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
    private var navigationBar = NavigationBar()
    private var scrollView = UIScrollView()
    private var itemsView = ItemsView()
    private var localBitcoinCashView = UIView()
    private var bitcoinExchangeButton = UIButton()
    private var itemsViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        localize()
        registerForNotifications()
    }
    
    // MARK: - Actions
    @objc private func localBitcoinCashViewTapped() {
        AnalyticsService.shared.logEvent(.tapLocalAd)
        
        openLinkInSafari(link: Endpoints.localBitcoin)
    }
    
    @objc private func bitcoinExchangeButtonTapped() {
        AnalyticsService.shared.logEvent(.tapExchangeAd)
        
        openLinkInSafari(link: Endpoints.exchangeBitcoin)
    }
    
    @objc private func refresh() {
        itemsView.refresh()
    }
    
    // MARK: - Private API
    private func setupView() {
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupScrollView()
        setupItemsView()
        setupLocalBitcoinCashView()
        setupBitcoinExchangeButton()
    }
    
    private func setupNavigationBar() {
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
    
    private func setupLocalBitcoinCashView() {
        localBitcoinCashView.translatesAutoresizingMaskIntoConstraints = false
        localBitcoinCashView.isUserInteractionEnabled = true
        scrollView.addSubview(localBitcoinCashView)
        NSLayoutConstraint.activate([
            localBitcoinCashView.leadingAnchor.constraint(equalTo: itemsView.leadingAnchor, constant: Constants.BUTTON_HORIZONTAL_PADDING),
            localBitcoinCashView.trailingAnchor.constraint(equalTo: itemsView.trailingAnchor, constant: -Constants.BUTTON_HORIZONTAL_PADDING),
            localBitcoinCashView.topAnchor.constraint(equalTo: itemsView.bottomAnchor, constant: Constants.LOCAL_BITCOIN_CASH_VIEW_TOP_MARGIN),
            localBitcoinCashView.heightAnchor.constraint(equalToConstant: Constants.BUTTON_HEIGHT)
        ])
        
        // Tap Gesture.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(localBitcoinCashViewTapped))
        localBitcoinCashView.addGestureRecognizer(tapGestureRecognizer)
        
        // Image.
        let imageView = UIImageView(image: UIImage(imageLiteralResourceName: "localbch_banner"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        localBitcoinCashView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: localBitcoinCashView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: localBitcoinCashView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: localBitcoinCashView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: localBitcoinCashView.bottomAnchor)
        ])
    }
    
    private func setupBitcoinExchangeButton() {
        bitcoinExchangeButton.setImage(UIImage(imageLiteralResourceName: "bce_banner"), for: .normal)
        bitcoinExchangeButton.imageView?.contentMode = .scaleAspectFit
        bitcoinExchangeButton.imageView?.clipsToBounds = true
        bitcoinExchangeButton.addTarget(self, action: #selector(bitcoinExchangeButtonTapped), for: .touchUpInside)
        bitcoinExchangeButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(bitcoinExchangeButton)
        NSLayoutConstraint.activate([
            bitcoinExchangeButton.leadingAnchor.constraint(equalTo: localBitcoinCashView.leadingAnchor),
            bitcoinExchangeButton.trailingAnchor.constraint(equalTo: localBitcoinCashView.trailingAnchor),
            bitcoinExchangeButton.topAnchor.constraint(equalTo: localBitcoinCashView.bottomAnchor, constant: Constants.BUTTON_TOP_PADDING),
            bitcoinExchangeButton.heightAnchor.constraint(equalToConstant: Constants.BUTTON_HEIGHT)
        ])
    }
    
    private func localize() {
        navigationBar.text = Localized.settings
    }
    
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .refreshSettings, object: nil)
    }
    
    private func updateMerchantName() {
        let alertController = UIAlertController(title: UserItem.merchantName.title, message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: Localized.cancel, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: Localized.OK, style: .default) { _ in
            if let textField = alertController.textFields?.first {
                if let text = textField.text {
                    UserManager.shared.companyName = text
                    alertController.dismiss(animated: true) { [weak self] in
                        self?.refreshAndShowSuccessMessage()
                    }
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
        let paymentTarget = PaymentTarget(address: address, type: .address)
        
        if paymentTarget.type == .invalid {
            showFailureMessage()
        } else {
            UserManager.shared.destination = paymentTarget.address
            UserManager.shared.activePaymentTarget = paymentTarget
            
            if paymentTarget.type == .xPub {
                refreshItemsView()
                syncXPub(paymentTarget.address)
            } else {
                refreshAndShowSuccessMessage()
            }
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
    
    private func syncXPub(_ address: String) {
        ToastManager.shared.showMessage(Localized.syncingXPub, forStatus: .success)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            WalletManager.shared.syncXPub(with: address)
            ToastManager.shared.showMessage(Localized.syncedXPub, forStatus: .success)
        }
    }

}

extension SettingsViewController: ItemsViewDelegate {
    
    // MARK: - ItemsViewDelegate
    func itemsView(_ itemsView: ItemsView, didTapOnItem item: Item) {
        if item.title == UserItem.pin.title { // Create PIN.
            AnalyticsService.shared.logEvent(.editPin)
            
            createPin()
        }
        
        if item.title == UserItem.merchantName.title { // Update Merchant name.
            AnalyticsService.shared.logEvent(.editName)
            
            updateMerchantName()
        }
        
        if item.title == UserItem.destinationAddress.title { // Destination address.
            AnalyticsService.shared.logEvent(.editDestination)
            
            showAddDestionationAddressAlert()
        }
        
        if item.title == UserItem.localCurrency.title { // Local Currency.
            AnalyticsService.shared.logEvent(.editCurrency)
            
            pickCurrency()
        }
    }
    
}

extension SettingsViewController: PinViewControllerDelegate {
    
    // MARK: - PinViewControllerDelegate
    func pinViewControllerDidEnterPinSuccessfully(_ viewController: PinViewController) {}
    
    func pinViewControllerDidCreatePinSuccessfully(_ viewController: PinViewController) {
        viewController.dismiss(animated: true) { [weak self] in
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
            UserManager.shared.selectedCurrency = currency
            self?.refreshAndShowSuccessMessage()
        }
    }
    
}

private struct Constants {
    static let ITEMS_VIEW_MARGIN: CGFloat = 35.0
    static let LOCAL_BITCOIN_CASH_VIEW_TOP_MARGIN: CGFloat = 30.0
    static let BUTTON_HORIZONTAL_PADDING: CGFloat = 10.0
    static let BUTTON_TOP_PADDING: CGFloat = 20.0
    static let BUTTON_HEIGHT: CGFloat = 100.0
    static let LABEL_PADDING: CGFloat = 10.0
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
}
