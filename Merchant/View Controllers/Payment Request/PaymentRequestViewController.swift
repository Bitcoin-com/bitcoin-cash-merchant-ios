//
//  PaymentRequestViewController.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/20/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import UIKit
import RealmSwift
import BitcoinKit

final class PaymentRequestViewController: UIViewController {

    // MARK: - Properties
    private var cancelButton = UIButton()
    private var shareButton = UIButton()
    private var connectionStatusImageView = UIImageView()
    private var qrContainerView = CardView()
    private var activityIndicatorView = UIActivityIndicatorView(style: .large)
    private var qrImageView = UIImageView()
    private var timeRemainingLabel = UILabel()
    private var scanToPayLabel = UILabel()
    private var amountLabel = UILabel()
    private var paymentCompletedView = PaymentCompletedView()
    private var timer: Timer?
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = UserManager.shared.selectedCurrency.decimals
        formatter.maximumFractionDigits = UserManager.shared.selectedCurrency.decimals
        formatter.usesGroupingSeparator = true
        formatter.locale = UserManager.shared.selectedCurrency.locale
        
        return formatter
    }
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        return formatter
    }()
    var amount = 0.0
    var invoice: InvoiceStatus? {
        didSet {
            setupTimer()
            setupQrCode()
            setupSocket()
        }
    }
    private var webSocket: WebSocket?
    private var qrImage: UIImage?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        localize()
        createInvoice()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        webSocket?.close()
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Actions
    @objc private func cancelButtonTapped() {
        AnalyticsService.shared.logEvent(.invoice_cancelled)
        
        UserManager.shared.activeInvoice = nil
        dismiss(animated: true)
    }
    
    @objc private func shareButtonTapped() {
        guard let invoice = invoice else { return }
        
        AnalyticsService.shared.logEvent(.invoice_shared)
        
        var activityItems = [Any]()
        
        if let image = qrImage {
            activityItems.append(image)
        }
        
        let paymentUrl = "\(BASE_URL)/i/\(invoice.paymentId)"
        let pleasePay = String(format: Localized.pleasePayYourInvoiceHere, paymentUrl)
        activityItems.append(pleasePay)
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        present(activityViewController, animated: true)
    }
    
    @objc private func timerTick() {
        guard let invoice = invoice else { return }
        
        let expiresDate = dateFormatter.date(from: invoice.expires)!
        
        let difference = Calendar.current.dateComponents([.second], from: expiresDate, to: Date())
        let time = 24*60*60 - difference.second!
        
        if invoice.isTimerExpired {
            timer?.invalidate()
            timer = nil
            
            cancelButtonTapped()
        }
        
        timeRemainingLabel.text = time.toMinutesSeconds()
        timeRemainingLabel.alpha = 1.0
    }
    
    @objc private func qrImageViewTapped() {
        guard let invoice = invoice else { return }
        
        let url = "\(Endpoints.wallet)\(BASE_URL)/i/\(invoice.paymentId)"
        
        UIPasteboard.general.string = url
        ToastManager.shared.showMessage(url, forStatus: .success)
    }
    
    @objc private func networkConnectionLost() {
        connectionStatusImageView.image = UIImage(imageLiteralResourceName: "disconnected")
    }
    
    @objc private func networkConnectionAcquired() {
        connectionStatusImageView.image = UIImage(imageLiteralResourceName: "connected")
        
        if invoice == nil {
            createInvoice()
        }
    }
    
    // MARK: - Private API
    private func setupView() {
        view.backgroundColor = .white
        
        setupCancelButton()
        setupShareButton()
        setupConnectionStatusImageView()
        setupQrContainerView()
        setupQrImageView()
        setupActivityIndicatorView()
        setupTimeRemainingLabel()
        setupScanToPayLabel()
        setupAmountLabel()
        setupPaymentCompletedView()
        registerForNotifications()
    }
    
    private func setupCancelButton() {
        cancelButton.accessibilityIdentifier = Tests.PaymentRequest.cancelButton
        cancelButton.setImage(UIImage(imageLiteralResourceName: "close"), for: .normal)
        cancelButton.tintColor = .black
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        view.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.CANCEL_BUTTON_LEADING_MARGIN),
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.CANCEL_BUTTON_TOP_MARGIN),
            cancelButton.widthAnchor.constraint(equalToConstant: Constants.CANCEL_BUTTON_SIZE),
            cancelButton.heightAnchor.constraint(equalToConstant: Constants.CANCEL_BUTTON_SIZE)
        ])
    }
    
    private func setupShareButton() {
        shareButton.setImage(UIImage(imageLiteralResourceName: "share"), for: .normal)
        shareButton.tintColor = .white
        shareButton.backgroundColor = .bitcoinGreen
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        shareButton.addStandardCornedRadiusAndShadow()
        shareButton.layer.cornerRadius = Constants.SHARE_BUTTON_SIZE / 2
        view.addSubview(shareButton)
        NSLayoutConstraint.activate([
            shareButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.SHARE_BUTTON_TRAILING_MARGIN),
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.SHARE_BUTTON_BOTTOM_MARGIN),
            shareButton.widthAnchor.constraint(equalToConstant: Constants.SHARE_BUTTON_SIZE),
            shareButton.heightAnchor.constraint(equalToConstant: Constants.SHARE_BUTTON_SIZE)
        ])
    }
    
    private func setupConnectionStatusImageView() {
        connectionStatusImageView.accessibilityIdentifier = Tests.PaymentRequest.connectionStatusImageView
        connectionStatusImageView.image = NetworkManager.shared.isConnected ? UIImage(imageLiteralResourceName: "connected") : UIImage(imageLiteralResourceName: "disconnected")
        connectionStatusImageView.contentMode = .scaleAspectFit
        connectionStatusImageView.clipsToBounds = true
        connectionStatusImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(connectionStatusImageView)
        NSLayoutConstraint.activate([
            connectionStatusImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.CONNECTION_STATUS_IMAGE_VIEW_MARGIN),
            connectionStatusImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.CONNECTION_STATUS_IMAGE_VIEW_MARGIN),
            connectionStatusImageView.widthAnchor.constraint(equalToConstant: Constants.CONNECTION_STATUS_IMAGE_VIEW_SIZE),
            connectionStatusImageView.heightAnchor.constraint(equalToConstant: Constants.CONNECTION_STATUS_IMAGE_VIEW_SIZE)
        ])
    }
    
    private func setupQrContainerView() {
        qrContainerView.backgroundColor = .white
        qrContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(qrContainerView)
        NSLayoutConstraint.activate([
            qrContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            qrContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            qrContainerView.widthAnchor.constraint(equalToConstant: Constants.QR_CONTAINER_VIEW_SIZE),
            qrContainerView.heightAnchor.constraint(equalToConstant: Constants.QR_CONTAINER_VIEW_SIZE)
        ])
    }
    
    private func setupQrImageView() {
        qrImageView.accessibilityIdentifier = Tests.PaymentRequest.qrImageView
        qrImageView.contentMode = .scaleAspectFit
        qrImageView.translatesAutoresizingMaskIntoConstraints = false
        qrImageView.isUserInteractionEnabled = false
        qrContainerView.addSubview(qrImageView)
        NSLayoutConstraint.activate([
            qrImageView.leadingAnchor.constraint(equalTo: qrContainerView.leadingAnchor, constant: Constants.QR_IMAGE_VIEW_PADDING),
            qrImageView.trailingAnchor.constraint(equalTo: qrContainerView.trailingAnchor, constant: -Constants.QR_IMAGE_VIEW_PADDING),
            qrImageView.topAnchor.constraint(equalTo: qrContainerView.topAnchor, constant: Constants.QR_IMAGE_VIEW_PADDING),
            qrImageView.bottomAnchor.constraint(equalTo: qrContainerView.bottomAnchor, constant: -Constants.QR_IMAGE_VIEW_PADDING)
        ])
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(qrImageViewTapped))
        qrImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupActivityIndicatorView() {
        activityIndicatorView.color = .bitcoinGreen
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        qrContainerView.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: qrContainerView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: qrContainerView.centerYAnchor)
        ])
        
        if invoice == nil {
            activityIndicatorView.startAnimating()
        }
    }
    
    private func setupTimeRemainingLabel() {
        timeRemainingLabel.textColor = .bitcoinGreen
        timeRemainingLabel.alpha = 0.0
        timeRemainingLabel.textAlignment = .center
        timeRemainingLabel.font = .boldSystemFont(ofSize: Constants.TIME_REMAINING_LABEL_FONT_SIZE)
        timeRemainingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timeRemainingLabel)
        NSLayoutConstraint.activate([
            timeRemainingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeRemainingLabel.topAnchor.constraint(equalTo: qrContainerView.bottomAnchor, constant: Constants.TIME_REMAINING_LABEL_TOP_MARGIN)
        ])
    }
    
    private func setupScanToPayLabel() {
        scanToPayLabel.textColor = .bitcoinGreen
        scanToPayLabel.textAlignment = .center
        scanToPayLabel.numberOfLines = 0
        scanToPayLabel.font = .boldSystemFont(ofSize: Constants.SCAN_TO_PAY_LABEL_FONT_SIZE)
        scanToPayLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scanToPayLabel)
        NSLayoutConstraint.activate([
            scanToPayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppConstants.GENERAL_MARGIN),
            scanToPayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppConstants.GENERAL_MARGIN),
            scanToPayLabel.bottomAnchor.constraint(equalTo: qrContainerView.topAnchor, constant: -Constants.SCAN_TO_PAY_LABEL_BOTTOM_MARGIN)
        ])
    }
    
    private func setupAmountLabel() {
        amountLabel.textColor = .black
        amountLabel.adjustsFontSizeToFitWidth = true
        amountLabel.textAlignment = .center
        amountLabel.font = .boldSystemFont(ofSize: Constants.AMOUNT_LABEL_FONT_SIZE)
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(amountLabel)
        NSLayoutConstraint.activate([
            amountLabel.bottomAnchor.constraint(equalTo: scanToPayLabel.topAnchor, constant: -Constants.AMOUNT_LABEL_BOTTOM_MARGIN),
            amountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.AMOUNT_LABEL_HORIZONTAL_MARGIN),
            amountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.AMOUNT_LABEL_HORIZONTAL_MARGIN)
        ])
    }
    
    private func setupPaymentCompletedView() {
        paymentCompletedView.alpha = 0.0
        paymentCompletedView.translatesAutoresizingMaskIntoConstraints = false
        paymentCompletedView.onDone = { [weak self] in self?.dismiss(animated: true) }
        view.addSubview(paymentCompletedView)
        NSLayoutConstraint.activate([
            paymentCompletedView.topAnchor.constraint(equalTo: view.topAnchor),
            paymentCompletedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            paymentCompletedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paymentCompletedView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(networkConnectionLost), name: .networkMonitorDidLostConnection, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(networkConnectionAcquired), name: .networkMonitorDidAcquireConnection, object: nil)
    }
    
    private func localize() {
        scanToPayLabel.text = Localized.scanToPay
        timeRemainingLabel.text = "0:00"
        
        if let invoice = invoice {
            amountLabel.text = "\(numberFormatter.string(from: NSNumber(value: invoice.fiatTotal)) ?? "")"
        } else {
            amountLabel.text = "\(numberFormatter.string(from: NSNumber(value: amount)) ?? "")"
        }
    }
    
    private func createInvoice() {
        guard invoice == nil, let paymentTarget = UserManager.shared.activePaymentTarget else { return }
        
        let invoiceRequest = InvoiceRequest(fiatAmount: amount,
                                            fiat: UserManager.shared.selectedCurrency.currency,
                                            apiKey: paymentTarget.invoiceRequestApiKey,
                                            address: paymentTarget.invoiceRequestAddress)
        
        BIP70Service.shared.createInvoice(invoiceRequest) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                AnalyticsService.shared.logEvent(.invoice_created)
                
                self.invoice = try? JSONDecoder().decode(InvoiceStatus.self, from: data)
                UserManager.shared.activeInvoice = self.invoice
            case .failure(let error):
                Logger.log(message: "Error creating invoice: \(error.localizedDescription)", type: .error)
                AnalyticsService.shared.logEvent(.error_download_invoice, withError: error)
                self.showErrorAlert(error.localizedDescription)
            }
        }
    }
    
    private func setupQrCode() {
        guard let invoice = invoice, let url = URL(string: "\(Endpoints.wallet)\(BASE_URL)/i/\(invoice.paymentId)") else { return }
        
        activityIndicatorView.stopAnimating()
        
        Logger.log(message: "Generating QR for URL: \(url.absoluteString)", type: .info)
        
        if let image = url.qrImage {
            qrImageView.image = UIImage(ciImage: image)
            qrImage = UIImage(ciImage: image)
            qrImageView.isUserInteractionEnabled = true
        } else {
            AnalyticsService.shared.logEvent(.error_generate_qr_code, withError: QRError.notAbleToGenerateQR)
            showErrorAlert(QRError.notAbleToGenerateQR.localizedDescription)
        }
    }
    
    private func setupTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }
    
    private func saveTransaction(for invoice: InvoiceStatus) {
        let realm = try! Realm()

        let transaction = StoreTransaction()
        transaction.amountInFiat = amountLabel.text!
        transaction.amountInSatoshis = 0
        
        if let amount = invoice.outputs.first?.amount {
            transaction.amountInSatoshis = Int64(amount)
        }
        
        if let address = invoice.outputs.first?.address {
            transaction.toAddress = address
        }
        
        transaction.txid = invoice.txId ?? ""
        transaction.date = Date()

        try! realm.write {
            realm.add(transaction)
        }
    }
    
    private func showPaymentCompletedView(for invoiceStatus: InvoiceStatus) {
        // If the invoiceStatus paymentId is the same as the one which is already stored - do not send analytics event again.
        if let paymentId = UserManager.shared.lastProcessedPaymentId {
            if paymentId == invoiceStatus.paymentId {
                return
            }
        }
        
        AnalyticsService.shared.logEvent(.invoice_paid)
        
        // Increase the next index for xPubKey.
        if let paymentTarget = UserManager.shared.activePaymentTarget, paymentTarget.type == .xPub {
            UserManager.shared.xPubKeyIndex += 1
        }
        
        UIView.animate(withDuration: AppConstants.ANIMATION_DURATION) {
            self.paymentCompletedView.alpha = 1.0
        }
    }
    
    private func setupSocket() {
        guard let invoice = invoice else { return }
        
        if let url = URL(string: "\(Endpoints.websocket)/\(invoice.paymentId)") {
            let webSocket = WebSocket(request: URLRequest(url: url))
            webSocket.event.message = { message in
                if let messageString = message as? String, let data = messageString.data(using: .utf8) {
                    Logger.log(message: "Received message: \(messageString)", type: .success)
                    
                    if let invoiceStatus = try? JSONDecoder().decode(InvoiceStatus.self, from: data) {
                        if invoiceStatus.isPaid {
                            self.saveTransaction(for: invoiceStatus)
                            self.showPaymentCompletedView(for: invoiceStatus)
                            UserManager.shared.activeInvoice = nil
                            UserManager.shared.lastProcessedPaymentId = invoiceStatus.paymentId
                        }
                    }
                }
            }
            webSocket.event.open = { [weak self] in
                Logger.log(message: "Socket did open", type: .success)
                self?.networkConnectionAcquired()
            }
            webSocket.event.close = { [weak self] code, reason, clean in
                Logger.log(message: "Socket did close", type: .debug)
                self?.networkConnectionLost()
            }
            webSocket.event.error = { [weak self] error in
                guard let self = self else { return }
                AnalyticsService.shared.logEvent(.error_connect_to_socket, withError: error)
                self.showErrorAlert(error.localizedDescription)
            }
            
            self.webSocket = webSocket
        }
    }
    
    private func pingWebSocket() {
        webSocket?.ping()
    }

}

private struct Localized {
    static var scanToPay: String { NSLocalizedString("waiting_for_payment", comment: "") }
    static var pleasePayYourInvoiceHere: String { NSLocalizedString("share_invoice_msg", comment: "") }
}

private struct Constants {
    static let CONNECTION_STATUS_IMAGE_VIEW_MARGIN: CGFloat = 20.0
    static let CONNECTION_STATUS_IMAGE_VIEW_SIZE: CGFloat = 30.0
    static let CANCEL_BUTTON_SIZE: CGFloat = 44.0
    static let CANCEL_BUTTON_LEADING_MARGIN: CGFloat = 10.0
    static let CANCEL_BUTTON_TOP_MARGIN: CGFloat = 10.0
    static let SHARE_BUTTON_SIZE: CGFloat = 50.0
    static let SHARE_BUTTON_TRAILING_MARGIN: CGFloat = 20.0
    static let SHARE_BUTTON_BOTTOM_MARGIN: CGFloat = 20.0
    static let QR_CONTAINER_VIEW_SIZE: CGFloat = UIScreen.main.bounds.size.width - 100.0
    static let QR_IMAGE_VIEW_PADDING: CGFloat = 10.0
    static let TIME_REMAINING_LABEL_FONT_SIZE: CGFloat = 18.0
    static let TIME_REMAINING_LABEL_TOP_MARGIN: CGFloat = 20.0
    static let SCAN_TO_PAY_LABEL_FONT_SIZE: CGFloat = 20.0
    static let SCAN_TO_PAY_LABEL_BOTTOM_MARGIN: CGFloat = 60.0
    static let AMOUNT_LABEL_FONT_SIZE: CGFloat = 60.0
    static let AMOUNT_LABEL_BOTTOM_MARGIN: CGFloat = 20.0
    static let AMOUNT_LABEL_HORIZONTAL_MARGIN: CGFloat = 20.0
}
