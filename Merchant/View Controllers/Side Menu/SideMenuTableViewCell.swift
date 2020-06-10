//
//  SideMenuTableViewCell.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/20/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import UIKit

final class SideMenuTableViewCell: UITableViewCell {

    // MARK: - Properties
    private var iconImageView = UIImageView()
    private var titleLabel = UILabel()
    private var borderView = UIView()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public API
    func setMenuItem(_ menuItem: MenuItem) {
        iconImageView.image = menuItem.image
        titleLabel.text = menuItem.description
        borderView.isHidden = menuItem.isBorderHidden
    }
    
    // MARK: - Private API
    private func setupView() {
        setupIconImageView()
        setupTitleLabel()
        setupBorderView()
    }
    
    private func setupIconImageView() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .black
        iconImageView.clipsToBounds = true
        contentView.addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.ICON_MARGIN),
            iconImageView.widthAnchor.constraint(equalToConstant: Constants.ICON_SIZE),
            iconImageView.heightAnchor.constraint(equalToConstant: Constants.ICON_SIZE)
        ])
    }
    
    private func setupTitleLabel() {
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .boldSystemFont(ofSize: 16.0)
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: Constants.TITLE_LABEL_MARGIN),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.TITLE_LABEL_MARGIN)
        ])
    }
    
    private func setupBorderView() {
        borderView.alpha = 0.5
        borderView.backgroundColor = .gray
        borderView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(borderView)
        NSLayoutConstraint.activate([
            borderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            borderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            borderView.heightAnchor.constraint(equalToConstant: Constants.BORDER_HEIGHT)
        ])
    }

}

private struct Constants {
    static let ICON_MARGIN: CGFloat = 20.0
    static let ICON_SIZE: CGFloat = 30.0
    static let TITLE_LABEL_MARGIN: CGFloat = 30.0
    static let BORDER_HEIGHT: CGFloat = 1.0
}
