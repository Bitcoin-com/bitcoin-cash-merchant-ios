//
//  AboutViewController.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/21/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import UIKit

final class AboutViewController: UIViewController {
    
    // MARK: - Properties
    private var navigationBar = NavigationBar()
    private var logoButton = UIButton()
    private var appNameLabel = UILabel()
    private var appVersionLabel = UILabel()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        localize()
    }
    
    // MARK: - Actions
    @objc private func logoButtonTapped() {
        openLinkInSafari(link: Endpoints.bitcoin)
    }
    
    // MARK: - Private API
    private func setupView() {
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupLogoButton()
        setupAppNameLabel()
        setupAppVersionLabel()
    }
    
    private func setupNavigationBar() {
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.onClose = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        view.addSubview(navigationBar)
        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: NavigationBar.height)
        ])
    }
    
    private func setupLogoButton() {
        logoButton.setImage(UIImage(imageLiteralResourceName: "bitcoincom_logo"), for: .normal)
        logoButton.addTarget(self, action: #selector(logoButtonTapped), for: .touchUpInside)
        logoButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoButton)
        NSLayoutConstraint.activate([
            logoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoButton.widthAnchor.constraint(equalToConstant: Constants.LOGO_BUTTON_WIDTH),
            logoButton.heightAnchor.constraint(equalToConstant: Constants.LOGO_BUTTON_HEIGHT)
        ])
    }
    
    private func setupAppNameLabel() {
        appNameLabel.textColor = .black
        appNameLabel.font = .boldSystemFont(ofSize: 25.0)
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(appNameLabel)
        NSLayoutConstraint.activate([
            appNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appNameLabel.topAnchor.constraint(equalTo: logoButton.bottomAnchor, constant: Constants.APP_NAME_BOTTOM_MARGIN)
        ])
    }
    
    private func setupAppVersionLabel() {
        appVersionLabel.textColor = .black
        appVersionLabel.translatesAutoresizingMaskIntoConstraints = false
        appVersionLabel.font = .boldSystemFont(ofSize: 15.0)
        view.addSubview(appVersionLabel)
        NSLayoutConstraint.activate([
            appVersionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appVersionLabel.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: Constants.VERSION_TOP_MARGIN)
        ])
    }
    
    private func localize() {
        navigationBar.text = Localized.about
        appNameLabel.text = Localized.appName
        appVersionLabel.text = "\(Bundle.main.releaseVersionNumber) - \(Date().year)"
    }
    
}

private struct Constants {
    static let LOGO_BUTTON_HEIGHT: CGFloat = 44.0
    static let LOGO_BUTTON_WIDTH: CGFloat = UIScreen.main.bounds.size.width - 50.0
    static let APP_NAME_BOTTOM_MARGIN: CGFloat = 80.0
    static let VERSION_TOP_MARGIN: CGFloat = 20.0
}

private struct Localized {
    static var about: String { NSLocalizedString("menu_about", comment: "") }
    static var appName: String { NSLocalizedString("app_name", comment: "") }
}
