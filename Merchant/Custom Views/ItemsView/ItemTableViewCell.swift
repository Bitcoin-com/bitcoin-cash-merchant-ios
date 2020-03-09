//
//  ItemTableViewCell.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/22/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import UIKit

final class ItemTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    private var iconImageView = UIImageView()
    private var labelsStackView = UIStackView()
    private var titleLabel = UILabel()
    private var descriptionLabel = UILabel()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public API
    func setItem(_ item: Item) {
        iconImageView.image = item.image
        titleLabel.text = item.title
        descriptionLabel.text = item.description
    }
    
    // MARK: - Private API
    private func setupView() {
        setupIconImageView()
        setupLabelsStackView()
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
    
    private func setupLabelsStackView() {
        titleLabel.textColor = .gray
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .boldSystemFont(ofSize: Constants.TITLE_FONT_SIZE)
        
        descriptionLabel.textColor = .gray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = .systemFont(ofSize: Constants.DESCRIPTION_FONT_SIZE)
        
        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(descriptionLabel)
        labelsStackView.distribution = .fillProportionally
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 5
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelsStackView)
        NSLayoutConstraint.activate([
            labelsStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: Constants.TITLE_LABEL_MARGIN),
            labelsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.TITLE_LABEL_MARGIN)
        ])
    }
    
}

private struct Constants {
    static let ICON_MARGIN: CGFloat = 15.0
    static let ICON_SIZE: CGFloat = 30.0
    static let TITLE_LABEL_MARGIN: CGFloat = 15.0
    static let LABEL_OFFSET: CGFloat = 10.0
    static let BORDER_HEIGHT: CGFloat = 1.0
    static let TITLE_FONT_SIZE: CGFloat = 18.0
    static let DESCRIPTION_FONT_SIZE: CGFloat = 15.0
}
