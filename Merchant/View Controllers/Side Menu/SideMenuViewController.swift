//
//  SideMenuViewController.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/20/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import UIKit

final class SideMenuViewController: UIViewController {
    
    // MARK: - Properties
    private var tableView = UITableView()
    private var merchantNameLabel = UILabel()
    private var tableHeaderView = SideMenuTableHeaderView()
    private var items = [
        MenuItem.transactions,
        MenuItem.settings,
        MenuItem.termsOfUse,
        MenuItem.serviceTerms,
        MenuItem.privacyPolicy,
        MenuItem.about
    ]
    
    // MARK: - Layout Properties
    private var orientationConstraints : [NSLayoutConstraint] = [];
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { [self] (context) in
            NSLayoutConstraint.deactivate(orientationConstraints)
            
            let sideMenuOffset : CGFloat = valueForOrientation(portraitValue: AppConstants.SIDE_MENU_OFFSET_PORTRAIT, landscapeValue: AppConstants.SIDE_MENU_OFFSET_LANDSCAPE)
            orientationConstraints = [
                tableView.topAnchor.constraint(equalTo: view.topAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideMenuOffset)
            ]
            
            NSLayoutConstraint.activate(orientationConstraints)
        })
    }
    
    // MARK: - Private API
    private func setupView() {
        view.backgroundColor = .white
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.accessibilityIdentifier = Tests.SideMenu.tableView
        tableView.register(SideMenuTableViewCell.self, forCellReuseIdentifier: SideMenuTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        tableView.contentInsetAdjustmentBehavior = .never
        view.addSubview(tableView)
        
        let sideMenuOffset : CGFloat = valueForOrientation(portraitValue: AppConstants.SIDE_MENU_OFFSET_PORTRAIT, landscapeValue: AppConstants.SIDE_MENU_OFFSET_LANDSCAPE)
        orientationConstraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideMenuOffset)
        ]
        
        NSLayoutConstraint.activate(orientationConstraints)
        
        setupTableHeader()
        tableView.reloadData()
    }
    
    private func setupTableHeader() {
        var frame = tableHeaderView.frame
        frame.size.height = Constants.TABLE_HEADER_VIEW_HEIGHT
        
        tableHeaderView.frame = frame
        tableView.tableHeaderView = tableHeaderView
    }
    
    private func handleMenuItem(_ menuItem: MenuItem) {
        NotificationCenter.default.post(name: .hideSideMenu, object: nil)
        
        switch menuItem {
        case .transactions:
            AnalyticsService.shared.logEvent(.tap_transactions)
            
            let transactionsHistoryViewController = TransactionsHistoryViewController()
            NotificationCenter.default.post(name: .openViewController, object: transactionsHistoryViewController)
        case .settings:
            AnalyticsService.shared.logEvent(.tap_settings)
            
            NotificationCenter.default.post(name: .openSettings, object: nil)
        case .termsOfUse:
            AnalyticsService.shared.logEvent(.tap_termsofuse)
            
            NotificationCenter.default.post(name: .openLink, object: Endpoints.termsOfUse)
        case .serviceTerms:
            AnalyticsService.shared.logEvent(.tap_serviceterms)
            
            NotificationCenter.default.post(name: .openLink, object: Endpoints.serviceTerms)
        case .privacyPolicy:
            AnalyticsService.shared.logEvent(.tap_privacypolicy)
            
            NotificationCenter.default.post(name: .openLink, object: Endpoints.privacyPolicy)
        case .about:
            AnalyticsService.shared.logEvent(.tap_about)
            
            let aboutViewController = AboutViewController()
            NotificationCenter.default.post(name: .openViewController, object: aboutViewController)
        }
    }
    
}

extension SideMenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuTableViewCell.identifier, for: indexPath) as! SideMenuTableViewCell
        
        cell.setMenuItem(items[indexPath.item])
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        handleMenuItem(items[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.CELL_HEIGHT
    }
    
}

private struct Constants {
    static let CELL_HEIGHT: CGFloat = 70.0
    static let MENU_OFFSET: CGFloat = 100.0
    static let TABLE_HEADER_VIEW_HEIGHT: CGFloat = 220.0
}
