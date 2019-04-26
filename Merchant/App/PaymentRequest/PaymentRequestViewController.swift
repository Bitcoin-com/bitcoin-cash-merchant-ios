//
//  PaymentRequestViewController.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/23.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit
import Lottie

class PaymentRequestViewController: BDCViewController {
    
    var presenter: PaymentRequestPresenter?
    
    let qrImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let fiatAmountLabel: BDCLabel = {
        let label = BDCLabel.build(.title)
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
        
        title = "Payment request"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "close_icon"), style: .plain, target: self, action: #selector(didPushClose))
        
        let qrView = UIView()
        qrView.addSubview(qrImageView)
        
        // QR Code Image View
        qrImageView.centerXAnchor.constraint(equalTo: qrView.centerXAnchor).isActive = true
        qrImageView.centerYAnchor.constraint(equalTo: qrView.centerYAnchor).isActive = true
        qrImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        qrImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        let priceView = UIView()
        priceView.addSubview(fiatAmountLabel)
        
        fiatAmountLabel.centerXAnchor.constraint(equalTo: priceView.centerXAnchor).isActive = true
        fiatAmountLabel.centerYAnchor.constraint(equalTo: priceView.centerYAnchor).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [qrView, priceView])
        stackView.axis = .vertical
        
        view.addSubview(stackView)
        stackView.fillSuperView()
        
        view.addSubview(successAnimation)
        successAnimation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        successAnimation.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        successAnimation.widthAnchor.constraint(equalToConstant: 200).isActive = true
        successAnimation.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func onSetQRCode(withData data: String) {
        qrImageView.image = generateQRCode(withData: data)
    }
    
    func onSetAmount(_ fiatAmount: String) {
        fiatAmountLabel.text = fiatAmount
    }
    
    @objc func didPushClose() {
        presenter?.didPushClose()
    }
    
    func onSuccess() {
        successAnimation.isHidden = false
        successAnimation.play()
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
