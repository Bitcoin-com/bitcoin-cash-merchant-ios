//
//  SideMenuTableHeaderView.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/21/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation
import UIKit

final class SideMenuTableHeaderView: UIView {

    // MARK: - Properties
    private var iconContainerView = UIView()
    private var iconImageView = UIImageView()
    private var merchantNameLabel = UILabel()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    // MARK: - View Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            merchantNameLabel.centerXAnchor.constraint(equalTo: iconImageView.centerXAnchor),
            merchantNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.MERCHANT_NAME_LABEL_PADDING),
            merchantNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.MERCHANT_NAME_LABEL_PADDING),
            merchantNameLabel.topAnchor.constraint(equalTo: iconContainerView.bottomAnchor, constant: Constants.MERCHANT_NAME_LABEL_PADDING)
        ])
    }
    
    // MARK: - Actions
    @objc private func refresh() {
        merchantNameLabel.text = UserManager.shared.companyName
    }
    
    // MARK: - Private API
    private func setupView() {
        backgroundColor = .bitcoinGreen
        
        setupIconContainerView()
        setupIconImageView()
        setupMerchantNameLabel()
        registerForNotifications()
    }
    
    private func setupIconContainerView() {
        iconContainerView.backgroundColor = .white
        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.layer.cornerRadius = Constants.ICON_CONTAINER_VIEW_SIZE / 2
        addSubview(iconContainerView)
        NSLayoutConstraint.activate([
            iconContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconContainerView.widthAnchor.constraint(equalToConstant: Constants.ICON_CONTAINER_VIEW_SIZE),
            iconContainerView.heightAnchor.constraint(equalToConstant: Constants.ICON_CONTAINER_VIEW_SIZE)
        ])
    }
    
    private func setupIconImageView() {
        iconImageView.image = UIImage(imageLiteralResourceName: "market_house")
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .bitcoinGreen
        iconImageView.clipsToBounds = true
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: Constants.ICON_IMAGE_VIEW_SIZE),
            iconImageView.heightAnchor.constraint(equalToConstant: Constants.ICON_IMAGE_VIEW_SIZE)
        ])
    }
    
    private func setupMerchantNameLabel() {
        merchantNameLabel.text = UserManager.shared.companyName
        merchantNameLabel.textColor = .white
        merchantNameLabel.font = .boldSystemFont(ofSize: 16.0)
        merchantNameLabel.numberOfLines = 0
        merchantNameLabel.textAlignment = .center
        merchantNameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(merchantNameLabel)
    }
    
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .settingsUpdated, object: nil)
    }
    
}

private struct Constants {
    static let MERCHANT_NAME_FONT_SIZE: CGFloat = 16.0
    static let ICON_CONTAINER_VIEW_SIZE: CGFloat = 80.0
    static let ICON_IMAGE_VIEW_SIZE: CGFloat = 40.0
    static let MERCHANT_NAME_LABEL_PADDING: CGFloat = 20.0
}
