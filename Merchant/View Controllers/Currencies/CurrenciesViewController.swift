//
//  CurrenciesViewController.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/24/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import UIKit
import BitcoinKit

protocol CurrenciesViewControllerDelegate: class {
    func currenciesViewController(_ viewController: CurrenciesViewController, didPickCurrency currency: CountryCurrency)
}

final class CurrenciesViewController: UIViewController {

    // MARK: - Properties
    private var overlayButton = UIButton()
    private var itemsView = ItemsView()
    weak var delegate: CurrenciesViewControllerDelegate?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK: - Actions
    @objc private func overlayButtonTapped() {
        dismiss(animated: true)
    }
    
    // MARK: - Private API
    private func setupView() {
        view.backgroundColor = .white
        
        setupOverlayButton()
        setupItemsView()
    }
    
    private func setupOverlayButton() {
        overlayButton.alpha = 0.4
        overlayButton.backgroundColor = .black
        overlayButton.translatesAutoresizingMaskIntoConstraints = false
        overlayButton.addTarget(self, action: #selector(overlayButtonTapped), for: .touchUpInside)
        view.addSubview(overlayButton)
        NSLayoutConstraint.activate([
            overlayButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayButton.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    
    private func setupItemsView() {
        itemsView.accessibilityIdentifier = Tests.Currencies.itemsView
        itemsView.items = CurrencyManager.shared.countryCurrencies
        itemsView.isScrollEnabled = true
        itemsView.delegate = self
        itemsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(itemsView)
        NSLayoutConstraint.activate([
            itemsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.ITEMS_VIEW_MARGIN),
            itemsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.ITEMS_VIEW_MARGIN),
            itemsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.ITEMS_VIEW_MARGIN),
            itemsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.ITEMS_VIEW_MARGIN)
        ])
    }

}

extension CurrenciesViewController: ItemsViewDelegate {
    
    // MARK: - ItemsViewDelegate
    func itemsView(_ itemsView: ItemsView, didTapOnItem item: Item) {
        if let currency = item as? CountryCurrency {
            delegate?.currenciesViewController(self, didPickCurrency: currency)
        }
    }
    
}

private struct Constants {
    static let ITEMS_VIEW_MARGIN: CGFloat = 35.0
}
