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
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK: - Private API
    private func setupView() {
        view.backgroundColor = .white
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(SideMenuTableViewCell.self, forCellReuseIdentifier: SideMenuTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        tableView.contentInsetAdjustmentBehavior = .never
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppConstants.SIDE_MENU_OFFSET)
        ])
        
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
            let transactionsHistoryViewController = TransactionsHistoryViewController()
            NotificationCenter.default.post(name: .openViewController, object: transactionsHistoryViewController)
        case .settings:
            let settingsViewController = SettingsViewController()
            NotificationCenter.default.post(name: .openViewController, object: settingsViewController)
            NotificationCenter.default.post(name: .authorizeWithPin, object: settingsViewController)
        case .termsOfUse:
            NotificationCenter.default.post(name: .openLink, object: Endpoints.termsOfUse)
        case .serviceTerms:
            NotificationCenter.default.post(name: .openLink, object: Endpoints.serviceTerms)
        case .privacyPolicy:
            NotificationCenter.default.post(name: .openLink, object: Endpoints.privacyPolicy)
        case .about:
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
