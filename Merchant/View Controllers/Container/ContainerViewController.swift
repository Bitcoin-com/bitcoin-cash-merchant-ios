//
//  ContainerViewController.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/20/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import UIKit

final class ContainerViewController: UIViewController {
    
    // MARK: - Properties
    lazy var sideMenuViewController = SideMenuViewController()
    lazy var mainNavigationController: UINavigationController = {
        let navigationController = UINavigationController(rootViewController: PaymentInputViewController())
        navigationController.isNavigationBarHidden = true
        
        return navigationController
    }()
    private var isMenuOpened = false
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        registerForNotifications()
        
        if !UserManager.shared.hasPin {
            createPin()
        }
        
        if !UserManager.shared.hasDestinationAddress {
            showSettings()
        }
        
        if !UserManager.shared.isTermsAccepted {
            showAgreement()
        }
    }
    
    // MARK: - Actions
    @objc private func showSideMenu() {
        guard !isMenuOpened else {
            hideSideMenu()
            return
        }
        
        togglePaymentInputOverlayButton(to: true)
        
        isMenuOpened = true
        
        var sideMenuFrame = sideMenuViewController.view.frame
        sideMenuFrame.origin.x = -AppConstants.SIDE_MENU_OFFSET
        
        UIView.animate(withDuration: AppConstants.ANIMATION_DURATION) {
            self.sideMenuViewController.view.frame = sideMenuFrame
        }
    }
    
    @objc private func hideSideMenu() {
        isMenuOpened = false
        
        togglePaymentInputOverlayButton(to: false)
        
        var sideMenuFrame = sideMenuViewController.view.frame
        sideMenuFrame.origin.x = -UIScreen.main.bounds.size.width
        
        UIView.animate(withDuration: AppConstants.ANIMATION_DURATION) {
            self.sideMenuViewController.view.frame = sideMenuFrame
        }
    }
    
    @objc private func openViewController(_ notification: Notification) {
        isMenuOpened = false
        
        var frame = mainNavigationController.view.frame
        frame.origin.x = 0

        UIView.animate(withDuration: AppConstants.ANIMATION_DURATION, animations: {
            self.mainNavigationController.view.frame = frame
        }) { _ in
            if let viewController = notification.object as? UIViewController {
                self.mainNavigationController.pushViewController(viewController, animated: true)
            }
        }
    }
    
    @objc private func openLink(_ notification: Notification) {
        if let link = notification.object as? String {
            openLinkInSafari(link: link)
        }
    }
    
    @objc private func openSettings() {
        let pinViewController = PinViewController()
        pinViewController.state = .authorize
        pinViewController.view.frame.origin.y = UIScreen.main.bounds.size.height
        pinViewController.delegate = self
        
        addChild(pinViewController)
        view.addSubview(pinViewController.view)
        pinViewController.didMove(toParent: self)
        
        UIView.animate(withDuration: AppConstants.ANIMATION_DURATION) {
            pinViewController.view.frame.origin.y = 0
        }
    }
    
    @objc private func createPin() {
        let pinViewController = PinViewController()
        pinViewController.state = .create
        pinViewController.view.frame.origin.y = UIScreen.main.bounds.size.height
        pinViewController.delegate = self
        pinViewController.isCancelHidden = true
        
        addChild(pinViewController)
        view.addSubview(pinViewController.view)
        pinViewController.didMove(toParent: self)
        
        UIView.animate(withDuration: AppConstants.ANIMATION_DURATION) {
            pinViewController.view.frame.origin.y = 0
        }
    }
    
    // MARK: - Private API
    private func setupView() {
        addMainNavigationController()
        addSideMenuViewController()
    }
    
    private func addMainNavigationController() {
        addChild(mainNavigationController)
        view.addSubview(mainNavigationController.view)
        mainNavigationController.didMove(toParent: self)
    }
    
    private func addSideMenuViewController() {
        addChild(sideMenuViewController)
        view.addSubview(sideMenuViewController.view)
        sideMenuViewController.didMove(toParent: self)
        
        var frame = sideMenuViewController.view.frame
        frame.origin.x = -UIScreen.main.bounds.size.width
        sideMenuViewController.view.frame = frame
    }
    
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(showSideMenu), name: .showSideMenu, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideSideMenu), name: .hideSideMenu, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openViewController(_:)), name: .openViewController, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openLink(_:)), name: .openLink, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openSettings), name: .openSettings, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(createPin), name: .createPin, object: nil)
    }
    
    private func togglePaymentInputOverlayButton(to option: Bool) {
        if let paymentInputViewController = mainNavigationController.viewControllers.first as? PaymentInputViewController {
            paymentInputViewController.toggleOverlayButton(to: option)
        }
    }
    
    private func showSettings() {
        let settingsViewController = SettingsViewController()
        mainNavigationController.pushViewController(settingsViewController, animated: false)
    }
    
    private func showAgreement() {
        let agreementViewController = AgreementViewController()
        agreementViewController.modalPresentationStyle = .overCurrentContext
        agreementViewController.modalTransitionStyle = .crossDissolve
        present(agreementViewController, animated: false)
    }
    
    private func closePinViewController(_ viewController: PinViewController) {
        UIView.animate(withDuration: AppConstants.ANIMATION_DURATION) {
            viewController.view.frame.origin.y = UIScreen.main.bounds.size.height
        }
    }

}

extension ContainerViewController: PinViewControllerDelegate {
    
    // MARK: - PinViewControllerDelegate
    func pinViewControllerDidEnterPinSuccessfully(_ viewController: PinViewController) {
        showSettings()
        closePinViewController(viewController)
    }
    
    func pinViewControllerDidCreatePinSuccessfully(_ viewController: PinViewController) {
        closePinViewController(viewController)
    }
    
    func pinViewControllerDidClose(_ viewController: PinViewController) {
        closePinViewController(viewController)
    }
    
}
