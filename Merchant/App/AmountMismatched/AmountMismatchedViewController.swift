//
//  AmountMismatchedViewController.swift
//  Merchant
//
//  Created by Jennifer Eve Curativo on 23/09/2019.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import BDCKit

protocol AmountMismatchedViewDelegate: class {
    func showUnderpaid(by amount: Int64)
    func showOverpaid(by amount: Int64)
}

class AmountMismatchedViewController: BDCViewController {
    var presenter: AmountMismatchedPresenter!
    
    fileprivate let titleLabel: BDCLabel = {
        let label = BDCLabel.build(.header2)
        label.textAlignment = .center
        return label
    }()
    
    fileprivate let subtitleLabel: BDCLabel = {
        let label = BDCLabel.build(.header)
        label.textAlignment = .center
        return label
    }()
    
    fileprivate let amountInCoinLabel: BDCLabel = {
        let label = BDCLabel.build(.subtitle)
        label.textAlignment = .center
        return label
    }()
    
    var actionButtonHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupUI() {
        let closeButton = BDCButton.build(.type7)
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(didTapActionButton(_:)), for: .touchUpInside)
        view.addSubview(closeButton)

        closeButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        closeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, amountInCoinLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        stackView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive =  true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive =  true
    }

    @IBAction func didTapActionButton(_ sender: UIButton) {
        actionButtonHandler?()
    }
}

extension AmountMismatchedViewController: AmountMismatchedViewDelegate {
    func showUnderpaid(by amount: Int64) {
        titleLabel.text = "You underpaid by:"
        subtitleLabel.text = "\(amount) satoshis"
        amountInCoinLabel.text = amount.toBCHFormat()
    }
    
    func showOverpaid(by amount: Int64) {
        titleLabel.text = "You overpaid by:"
        subtitleLabel.text = "\(amount) satoshis"
        amountInCoinLabel.text = amount.toBCHFormat()
    }
}
