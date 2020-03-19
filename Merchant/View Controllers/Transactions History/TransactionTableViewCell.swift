//
//  TransactionTableViewCell.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/22/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import UIKit

final class TransactionTableViewCell: UITableViewCell {

    // MARK: - Properties
    private var iconImageView = UIImageView()
    private var fiatLabel = UILabel()
    private var bitcoinLabel = UILabel()
    private var dateLabel = UILabel()
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
    func setTranscation(_ transaction: StoreTransaction) {
        iconImageView.image = UIImage(imageLiteralResourceName: "doublecheck")
        fiatLabel.text = transaction.amountInFiat
        bitcoinLabel.text = transaction.amountInSatoshis.toBCHFormat()
        
        if Calendar.current.isDateInToday(transaction.date) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "'\(Localized.today)' '\n@ 'HH:mm"
            dateLabel.text = dateFormatter.string(from: transaction.date)
        } else if Calendar.current.isDateInYesterday(transaction.date) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "'\(Localized.yesterday)' '\n@ 'HH:mm"
            dateLabel.text = dateFormatter.string(from: transaction.date)
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE dd MMM '\n@ 'HH:mm"
            dateLabel.text = dateFormatter.string(from: transaction.date)
        }
    }
    
    // MARK: - Private API
    private func setupView() {
        setupIconImageView()
        setupFiatLabel()
        setupBitcoinLabel()
        setupDateLabel()
        setupBorderView()
    }
    
    private func setupIconImageView() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.tintColor = .bitcoinGreen
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.clipsToBounds = true
        contentView.addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.ICON_MARGIN),
            iconImageView.widthAnchor.constraint(equalToConstant: Constants.ICON_SIZE),
            iconImageView.heightAnchor.constraint(equalToConstant: Constants.ICON_SIZE)
        ])
    }
    
    private func setupFiatLabel() {
        fiatLabel.textColor = .black
        fiatLabel.translatesAutoresizingMaskIntoConstraints = false
        fiatLabel.font = .boldSystemFont(ofSize: Constants.FIAT_LABEL_FONT_SIZE)
        contentView.addSubview(fiatLabel)
        NSLayoutConstraint.activate([
            fiatLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor, constant: -Constants.LABEL_OFFSET),
            fiatLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: Constants.FIAT_LABEL_MARGIN)
        ])
    }
    
    private func setupBitcoinLabel() {
        bitcoinLabel.textColor = .gray
        bitcoinLabel.translatesAutoresizingMaskIntoConstraints = false
        bitcoinLabel.font = .boldSystemFont(ofSize: Constants.BITCOIN_LABEL_FONT_SIZE)
        contentView.addSubview(bitcoinLabel)
        NSLayoutConstraint.activate([
            bitcoinLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor, constant: 1.5 * Constants.LABEL_OFFSET),
            bitcoinLabel.leadingAnchor.constraint(equalTo: fiatLabel.leadingAnchor)
        ])
    }
    
    private func setupDateLabel() {
        dateLabel.textColor = .gray
        dateLabel.numberOfLines = 0
        dateLabel.textAlignment = .left
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = .systemFont(ofSize: Constants.DATE_LABEL_FONT_SIZE)
        contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.DATE_LABEL_MARGIN)
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

private struct Localized {
    static var today: String { NSLocalizedString("Today", comment: "") }
    static var yesterday: String { NSLocalizedString("Yesterday", comment: "") }
}

private struct Constants {
    static let ICON_MARGIN: CGFloat = 20.0
    static let ICON_SIZE: CGFloat = 30.0
    static let DATE_LABEL_MARGIN: CGFloat = 20.0
    static let DATE_LABEL_FONT_SIZE: CGFloat = 16.0
    static let FIAT_LABEL_MARGIN: CGFloat = 20.0
    static let FIAT_LABEL_FONT_SIZE: CGFloat = 30.0
    static let BITCOIN_LABEL_FONT_SIZE: CGFloat = 12.0
    static let LABEL_OFFSET: CGFloat = 10.0
    static let BORDER_HEIGHT: CGFloat = 1.0
}
