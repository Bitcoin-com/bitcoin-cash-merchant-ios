//
//  PaymentRequestViewController.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/23.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit
import Lottie
import BDCKit

class PaymentRequestViewController: BDCViewController {
    
    var presenter: PaymentRequestPresenter?
    var interactionController: CircleInteractionController?
    
    let qrImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let waitingLabel: BDCLabel = {
        let label = BDCLabel.build(.title)
        label.text = Constants.Strings.waitingForPayment
        label.textColor = .red
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let fiatAmountLabel: BDCLabel = {
        let label = BDCLabel.build(.header)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let bchAmountLabel: BDCLabel = {
        let label = BDCLabel.build(.subtitle)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let successAnimation: LOTAnimationView = {
        let animationView = LOTAnimationView(name: "success_animation")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.isHidden = true
        return animationView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Constants.Strings.paymentRequest
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "close_icon"), style: .plain, target: self, action: #selector(didPushClose))
        
        let qrView = UIView(frame: .zero)
        qrView.translatesAutoresizingMaskIntoConstraints = false
        qrView.addSubview(qrImageView)
        
        // QR Code Image View
        qrImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        qrImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        qrImageView.centerXAnchor.constraint(equalTo: qrView.centerXAnchor).isActive = true
        qrImageView.centerYAnchor.constraint(equalTo: qrView.centerYAnchor).isActive = true
        
        let priceView = UIStackView(arrangedSubviews: [fiatAmountLabel, bchAmountLabel])
        priceView.axis = .vertical
        priceView.distribution = .fill
        priceView.spacing = 8
        priceView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [waitingLabel, qrView, priceView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 32
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        qrView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        view.addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        qrImageView.addSubview(successAnimation)
        successAnimation.centerXAnchor.constraint(equalTo: qrImageView.centerXAnchor).isActive = true
        successAnimation.centerYAnchor.constraint(equalTo: qrImageView.centerYAnchor).isActive = true
        successAnimation.widthAnchor.constraint(equalToConstant: 200).isActive = true
        successAnimation.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        interactionController = CircleInteractionController(viewController: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        presenter?.viewDidDisappear()
    }
    
    func onSetQRCode(withData data: String) {
        qrImageView.image = generateQRCode(withData: data)
    }
    
    func onSetAmount(_ fiatAmount: String, bchAmount: String) {
        fiatAmountLabel.text = fiatAmount
        bchAmountLabel.text = bchAmount
    }
    
    @objc func didPushClose() {
        presenter?.didPushClose()
    }
    
    func onSuccess() {
        successAnimation.isHidden = false
        successAnimation.play()
        UIView.animate(withDuration: 0.2) {
            self.waitingLabel.alpha = 0
        }
    }
    
    func showAlert(_ title: String, message: String, action: String, actionHandler: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: action, style: .default) { _ in
            if let handler = actionHandler {
                handler()
            }
        }
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}

extension PaymentRequestViewController {
    
    fileprivate func generateQRCode(withData data: String) -> UIImage? {
        let parameters: [String : Any] = [
            "inputMessage": data.data(using: .utf8)!,
            "inputCorrectionLevel": "L"
        ]
        let filter = CIFilter(name: "CIQRCodeGenerator", parameters: parameters)
        
        guard let outputImage = filter?.outputImage else {
            return nil
        }
        
        let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: 6, y: 6))
        guard let cgImage = CIContext().createCGImage(scaledImage, from: scaledImage.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}
