//
//  VerificationView.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/21/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import UIKit

protocol VerificationViewDelegate: class {
    func verificationView(_ verificationView: VerificationView, didEnterCode code: String)
}

final class VerificationView: UIView {

    // MARK: - Properties
	private var labels = [UILabel]()
	private var linesStackView = UIStackView()
	private var labelsStackView = UIStackView()
	var numbersToVerify = 0 {
		didSet {
			setupView()
		}
	}
	private(set) var code = ""
	var text: String {
		set {
			code = newValue
			setText()
		}
		get {
			return code
		}
	}
	weak var delegate: VerificationViewDelegate?
	
	// MARK: - Public API
	func setNumbersRequired(_ numbersToVerify: Int) {
		self.numbersToVerify = numbersToVerify
	}
	
	func reset() {
		text = ""
		code = ""
	}
    
	// MARK: - Private API
	private func setupView() {
		setupLinesStackView()
		setupLabelsStackView()
	}
	
	private func setupLinesStackView() {
		for _ in 0..<numbersToVerify {
			let view = UIView()
			view.backgroundColor = .gray
            view.heightAnchor.constraint(equalToConstant: Constants.LINE_HEIGHT).isActive = true
			linesStackView.addArrangedSubview(view)
		}
		
		linesStackView.axis = .horizontal
		linesStackView.distribution = .fillEqually
		linesStackView.alignment = .center
        linesStackView.spacing = Constants.SPACING
        linesStackView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(linesStackView)
		NSLayoutConstraint.activate([
			linesStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
			linesStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
			linesStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            linesStackView.heightAnchor.constraint(equalToConstant: Constants.LINE_HEIGHT),
		])
	}
	
	private func setupLabelsStackView() {
		for _ in 0..<numbersToVerify {
			let label = createLabel()
			labelsStackView.addArrangedSubview(label)
			labels.append(label)
		}
		
		labelsStackView.axis = .horizontal
		labelsStackView.distribution = .fillEqually
		labelsStackView.alignment = .center
		labelsStackView.spacing = Constants.SPACING
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(labelsStackView)
		NSLayoutConstraint.activate([
			labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
			labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
			labelsStackView.topAnchor.constraint(equalTo: topAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: linesStackView.topAnchor, constant: -Constants.LABEL_TOP_MARGIN),
		])
	}
	
	private func createLabel() -> UILabel {
		let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.LABEL_FONT_SIZE)
        label.textColor = .black
		label.textAlignment = .center
		
		return label
	}
	
	private func setText() {
		labels.forEach { $0.text = "" }
		
		let length = min(numbersToVerify, code.count)
		for i in 0..<length {
			let label = labels[i]
			label.text = "●"
		}
		
		if length == numbersToVerify {
			delegate?.verificationView(self, didEnterCode: code)
		}
	}

}

private struct Constants {
    static let SPACING: CGFloat = 20.0
    static let LINE_HEIGHT: CGFloat = 2.0
    static let LABEL_TOP_MARGIN: CGFloat = 10.0
    static let LABEL_FONT_SIZE: CGFloat = 40.0
}
