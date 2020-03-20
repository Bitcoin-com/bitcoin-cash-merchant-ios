//
//  KeypadView.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/20/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import UIKit

protocol KeypadViewDelegate: class {
    func keypadView(_ keypadView: KeypadView, didTapOnNumber number: Int)
    func keypadViewDidTapOnDecimalPoint(_ keypadView: KeypadView)
    func keypadViewDidTapOnBackspace(_ keypadView: KeypadView)
}

final class KeypadView: CardView {

    // MARK: - Properties
    private var buttons = [UIButton]()
    weak var delegate: KeypadViewDelegate?
    static let KEYPAD_BUTTON_SIZE: CGFloat = UIScreen.main.bounds.size.width / 5
    var hasDecimalPoint = true {
        didSet {
            toggleDecimalPoint(hasDecimalPoint)
        }
    }
    
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
    @objc private func keypadButtonTapped(_ sender: UIButton) {
        if sender.image(for: .normal) != nil {
            delegate?.keypadViewDidTapOnBackspace(self)
        } else {
            if let title = sender.title(for: .normal) {
                if title == "." {
                    delegate?.keypadViewDidTapOnDecimalPoint(self)
                } else {
                    delegate?.keypadView(self, didTapOnNumber: Int(title) ?? 0)
                }
            }
        }
    }
    
    // MARK: - Private API
    private func setupView() {
        backgroundColor = .clear
        
        setupMainStackView()
    }
    
    private func setupMainStackView() {
        let firstRowStackView = createStackView(for: ["1", "2", "3"])
        let secondRowStackView = createStackView(for: ["4", "5", "6"])
        let thirdRowStackView = createStackView(for: ["7", "8", "9"])
        let fourthRowStackView = createStackView(for: [".", "0", UIImage(imageLiteralResourceName: "backspace")])
        
        let mainStackView = UIStackView(arrangedSubviews: [firstRowStackView, secondRowStackView, thirdRowStackView, fourthRowStackView])
        mainStackView.alignment = .fill
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = Constants.SPACING
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.SPACING),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.SPACING)
        ])
    }
    
    private func createStackView(for elements: [Any]) -> UIStackView {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = Constants.SPACING
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        elements.forEach {
            stackView.addArrangedSubview(configureKeypadButton($0))
        }
        
        return stackView
    }
    
    private func configureKeypadButton(_ element: Any) -> UIButton {
        let button = UIButton()
        
        if let title = element as? String {
            button.accessibilityIdentifier = title
            button.setTitle(title, for: .normal)
        } else if let image = element as? UIImage {
            button.setImage(image, for: .normal)
        }
        
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: Constants.KEYPAD_FONT_SIZE)
        button.addTarget(self, action: #selector(keypadButtonTapped(_:)), for: .touchUpInside)
        
        buttons.append(button)
        
        return button
    }
    
    private func toggleDecimalPoint(_ option: Bool) {
        buttons.forEach {
            if let title = $0.title(for: .normal) {
                if title == "." {
                    $0.alpha = option ? 1.0 : 0.0
                }
            }
        }
    }
    
}

private struct Constants {
    static let KEYPAD_FONT_SIZE: CGFloat = 60.0
    static let SPACING: CGFloat = 5.0
}
