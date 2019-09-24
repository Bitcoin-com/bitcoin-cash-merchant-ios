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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupUI() {
        let closeButton = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(didPushClose))
        navigationItem.leftBarButtonItem = closeButton
        
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
    
    @objc func didPushClose() {
        presenter.didPushClose()
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
