//
//  ToastViewController.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/20/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import UIKit

protocol ToastViewControllerDelegate: class {
	func toastViewControllerDidTapOnMessage(_ message: String)
	func toastViewControllerDidCloseMessage(_ message: String)
}

final class ToastViewController: UIViewController {
	
	// MARK: - Properties
	private let containerView = UIView()
	private let messageLabel = UILabel()
	private var messageHeight: CGFloat = 50.0
	private var containerViewBottomConstraint: NSLayoutConstraint?
	private var containerViewHeightConstraint: NSLayoutConstraint?
	var preferences = ToastPreferences()
	weak var delegate: ToastViewControllerDelegate?
	
	// MARK: - View Lifecycle
  	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupView()
	}
	
	// MARK: - Public API
    func displayMessage(_ message: String, forStatus status: ToastStatus) {
        containerView.backgroundColor = preferences.color(for: status)
        containerView.layer.cornerRadius = preferences.cornerRadius
        
		messageLabel.text = message
		messageLabel.font = preferences.font
        messageLabel.textColor = preferences.textColor
		
		updateConstraints()
		
		animateSlideIn { [weak self] in
			guard let self = self else { return }

			// Enable gestures only when the animation is fully completed.
			self.containerView.isUserInteractionEnabled = true;

			if self.preferences.autoclosing {
				DispatchQueue.main.asyncAfter(deadline: .now() + self.preferences.messageDuration) {
					self.animateSlideOut()
				}
			}
		}
	}
	
	// MARK: - Actions
	@objc private func containerViewSwiped() {
		animateSlideOut()
	}
	
	@objc private func containerViewTapped() {
		if let text = messageLabel.text {
			delegate?.toastViewControllerDidTapOnMessage(text)
		}
	}
	
	// MARK: - Private API
	private func setupView() {
		setupContainerView()
		setupMessageLabel()
	}
	
	private func setupContainerView() {
		containerView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(containerView)
		
		containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: messageHeight)
		containerViewBottomConstraint?.isActive = true
		
		containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: messageHeight)
		containerViewHeightConstraint?.isActive = true
		NSLayoutConstraint.activate([
			containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			])
		
		setupContainerViewGestures()
		containerView.isUserInteractionEnabled = false
	}
	
	private func setupContainerViewGestures() {
		let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(containerViewSwiped))
		swipeGestureRecognizer.direction = .up
		containerView.addGestureRecognizer(swipeGestureRecognizer)
		
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(containerViewTapped))
		containerView.addGestureRecognizer(tapGestureRecognizer)
	}
	
	private func setupMessageLabel() {
		messageLabel.numberOfLines = 0
		messageLabel.backgroundColor = .clear
		messageLabel.textAlignment = .left
		messageLabel.translatesAutoresizingMaskIntoConstraints = false
		containerView.addSubview(messageLabel)
		NSLayoutConstraint.activate([
			messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: preferences.inset),
			messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -preferences.inset),
			messageLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
			])
	}
	
	private func calculateMessageHeight(_ message: String, for font: UIFont) -> CGFloat {
		let width = UIScreen.main.bounds.size.width - 2 * preferences.inset
		let height = message.height(withConstrainedWidth: width, font: font)
		
		return height + 3 * preferences.inset
	}
	
	private func updateConstraints() {
		guard let message = messageLabel.text else { return }
		
		messageHeight = calculateMessageHeight(message, for: messageLabel.font)
		containerViewBottomConstraint?.constant = messageHeight
		containerViewHeightConstraint?.constant = messageHeight
		view.layoutIfNeeded()
	}
	
	private func animateSlideIn(_ completion: @escaping () -> Void) {
		containerViewBottomConstraint?.constant = 0.0
		
		UIView.animate(withDuration: preferences.animationDuration, delay: 0, options: .curveEaseOut, animations: {
			self.view.layoutIfNeeded()
		}) { _ in
			completion()
		}
	}
	
	private func animateSlideOut() {
		containerView.isUserInteractionEnabled = true;
		containerViewBottomConstraint?.constant = messageHeight
		
        UIView.animate(withDuration: preferences.animationDuration, delay: 0, options: .curveEaseOut, animations: {
			self.view.layoutIfNeeded()
		}) { _ in
			if let text = self.messageLabel.text {
				self.delegate?.toastViewControllerDidCloseMessage(text)
			}
		}
	}
	
}
