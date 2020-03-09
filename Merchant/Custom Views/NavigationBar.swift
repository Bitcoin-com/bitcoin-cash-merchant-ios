//
//  NavigationBar.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/21/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import UIKit

final class NavigationBar: UIView {

    // MARK: - Properties
    static let height: CGFloat = 80.0
    private var closeButton = UIButton()
    private var titleLabel = UILabel()
    var text: String? {
        didSet {
            titleLabel.text = text
        }
    }
    var onClose: (() -> Void)?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    // MARK: - Actions
    @objc private func closeTapped() {
        onClose?()
    }
    
    // MARK: - Private API
    private func setupView() {
        backgroundColor = .clear
        
        setupCloseButton()
        setupTitleLabel()
    }
    
    private func setupCloseButton() {
        closeButton.setImage(UIImage(imageLiteralResourceName: "arrow_left"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        closeButton.tintColor = .black
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.CLOSE_BUTTON_LEADING_MARGIN),
            closeButton.widthAnchor.constraint(equalToConstant: Constants.CLOSE_BUTTON_SIZE),
            closeButton.heightAnchor.constraint(equalToConstant: Constants.CLOSE_BUTTON_SIZE)
        ])
    }
    
    private func setupTitleLabel() {
        titleLabel.font = .boldSystemFont(ofSize: Constants.TITLE_FONT_SIZE)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: closeButton.trailingAnchor, constant: Constants.TITLE_LABEL_LEADING_MARGIN)
        ])
    }
    
}

private struct Constants {
    static let CLOSE_BUTTON_LEADING_MARGIN: CGFloat = 10.0
    static let CLOSE_BUTTON_SIZE: CGFloat = 44.0
    static let TITLE_FONT_SIZE: CGFloat = 20.0
    static let TITLE_LABEL_LEADING_MARGIN: CGFloat = 10.0
}
