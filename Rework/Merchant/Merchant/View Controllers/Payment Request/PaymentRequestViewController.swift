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
    private var qrImageView = UIImageView()
    private var timeRemainingLabel = UILabel()
    private var scanToPayLabel = UILabel()
    private var amountLabel = UILabel()
    private var paymentCompletedView = PaymentCompletedView()
    private var timer: Timer?
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
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
            fetchQrCode()
            setupSocket()
        }
    }
    var webSocket: WebSocket?
    var qrImage: UIImage?
    
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
    }
    
    // MARK: - Actions
    @objc private func cancelButtonTapped() {
        UserManager.shared.activeInvoice = nil
        dismiss(animated: true)
    }
    
    @objc private func shareButtonTapped() {
        guard let invoice = invoice else { return }
        
        var activityItems = [Any]()
        
        if let image = qrImage {
            activityItems.append(image)
        }
        
        let paymentUrl = "\(BASE_URL)/i/\(invoice.paymentId)"
        let pleasePay = "\(Localized.pleasePayYourInvoiceHere): \(paymentUrl)"
        activityItems.append(pleasePay)
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        present(activityViewController, animated: true)
    }
    
    @objc private func timerTick() {
        guard let invoice = invoice else { return }
        
        let expiresDate = dateFormatter.date(from: invoice.expires)!
        
        let difference = Calendar.current.dateComponents([.second], from: expiresDate, to: Date())
        let time = 24*60*60 - difference.second!
        
        if time == 0 {
            timer?.invalidate()
            timer = nil
            
            UserManager.shared.activeInvoice = nil
            dismiss(animated: true)
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
    
    // MARK: - Private API
    private func setupView() {
        view.backgroundColor = .white
        
        setupCancelButton()
        setupShareButton()
        setupConnectionStatusImageView()
        setupQrContainerView()
        setupQrImageView()
        setupTimeRemainingLabel()
        setupScanToPayLabel()
        setupAmountLabel()
        setupPaymentCompletedView()
    }
    
    private func setupCancelButton() {
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
        connectionStatusImageView.image = UIImage(imageLiteralResourceName: "connected")
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
        guard invoice == nil else { return }
        
        let invoice = InvoiceRequest(fiatAmount: amount,
                                     fiat: UserManager.shared.selectedCurrency.currency,
                                     apiKey: "sexqvmkxafvzhzfageoojrkchdekfwmuqpfqywsf",
                                     address: UserManager.shared.destination!)
        
        BIP70Service.shared.createInvoice(invoice) { result in
            switch result {
            case .success(let data):
                self.invoice = try? JSONDecoder().decode(InvoiceStatus.self, from: data)
                UserManager.shared.activeInvoice = self.invoice
            case .failure(let error):
                Logger.log(message: "Error creating invoice: \(error.localizedDescription)", type: .error)
            }
        }
    }
    
    private func fetchQrCode() {
        guard let invoice = invoice, let url = URL(string: "\(Endpoints.qr)/\(invoice.paymentId)") else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.qrImageView.image = UIImage(data: data)
                    self.qrImage = UIImage(data: data)
                    self.qrImageView.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    private func setupTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }
    
    private func showPaymentCompleteInfo() {
        
    }
    
    private func saveTransaction() {
        guard let invoice = invoice else { return }

        let realm = try! Realm()

        let transaction = StoreTransaction()
        transaction.amountInFiat = "\(invoice.fiatTotal)"
        transaction.amountInSatoshis = 0
        
        if let amount = invoice.outputs.first?.amount {
            transaction.amountInSatoshis = Int64(amount)
        }
        
        if let address = invoice.outputs.first?.address {
            transaction.toAddress = address
        }
        
        transaction.txid = invoice.paymentId
        transaction.date = Date()

        try! realm.write {
            realm.add(transaction)
        }
    }
    
    private func showPaymentCompletedView() {
        UIView.animate(withDuration: AppConstants.ANIMATION_DURATION) {
            self.paymentCompletedView.alpha = 1.0
        }
    }
    
    private func setupSocket() {
        guard let invoice = invoice else { return }
        
        if let url = URL(string: "\(Endpoints.websocket)/\(invoice.paymentId)") {
            let webSocket = WebSocket(request: URLRequest(url: url))
            webSocket.event.message = { message in
                print(message)
                if let messageString = message as? String, let data = messageString.data(using: .utf8) {
                    Logger.log(message: "Received message", type: .success)
                    if let invoiceStatus = try? JSONDecoder().decode(InvoiceStatus.self, from: data) {
                        if invoiceStatus.isPaid {
                            self.saveTransaction()
                            self.showPaymentCompletedView()
                            UserManager.shared.activeInvoice = nil
                        }
                    }
                }
            }
            webSocket.event.open = { [weak self] in
                Logger.log(message: "Socket did open", type: .success)
                self?.connectionStatusImageView.image = UIImage(imageLiteralResourceName: "connected")
            }
            
            webSocket.event.close = { [weak self] code, reason, clean in
                Logger.log(message: "Socket did close", type: .debug)
                self?.connectionStatusImageView.image = UIImage(imageLiteralResourceName: "disconnected")
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
    static var pleasePayYourInvoiceHere: String { NSLocalizedString("Please pay your invoice here", comment: "") }
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
    static let QR_CONTAINER_VIEW_SIZE: CGFloat = UIScreen.main.bounds.size.width / 2
    static let QR_IMAGE_VIEW_PADDING: CGFloat = 10.0
    static let TIME_REMAINING_LABEL_FONT_SIZE: CGFloat = 18.0
    static let TIME_REMAINING_LABEL_TOP_MARGIN: CGFloat = 20.0
    static let SCAN_TO_PAY_LABEL_FONT_SIZE: CGFloat = 20.0
    static let SCAN_TO_PAY_LABEL_BOTTOM_MARGIN: CGFloat = 60.0
    static let AMOUNT_LABEL_FONT_SIZE: CGFloat = 60.0
    static let AMOUNT_LABEL_BOTTOM_MARGIN: CGFloat = 20.0
    static let AMOUNT_LABEL_HORIZONTAL_MARGIN: CGFloat = 20.0
}

