//
//  TransactionsHistoryViewController.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/20/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import UIKit
import RealmSwift

final class TransactionsHistoryViewController: UIViewController {
    
    // MARK: - Properties
    private var navigationBar = NavigationBar()
    private var tableView = UITableView()
    private var transactions = [StoreTransaction]()
    var selectedTransaction: StoreTransaction?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        localize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchTransactions()
    }
    
    // MARK: - Private API
    private func setupView() {
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupTableView()
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
    
    private func setupTableView() {
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: TransactionTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        tableView.contentInsetAdjustmentBehavior = .never
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    private func localize() {
        navigationBar.text = Localized.transactions
    }
    
    private func fetchTransactions() {
        transactions.removeAll()
        
        let realm = try! Realm()
        
        let transactions = realm
            .objects(StoreTransaction.self)
            .sorted(byKeyPath: "date", ascending: false)
        
        transactions.forEach { [weak self] in
            self?.transactions.append($0)
        }
        
        tableView.reloadData()
    }
    
    private func showOptionsForTransaction() {
        guard let transaction = selectedTransaction else { return }
        
        let alertController = UIAlertController(title: nil, message: transaction.txid, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: Localized.cancel, style: .cancel, handler: nil)
        
        let viewTransactionAction = UIAlertAction(title: Localized.viewTranscation, style: .default, handler: { [weak self] _ in
            self?.openLinkInSafari(link: "\(Endpoints.explorerBitcoin)/tx/\(transaction.txid)")
        })
        
        let viewAllTransactionsAction = UIAlertAction(title: Localized.viewAllTranscations, style: .default, handler: { [weak self] _ in
            self?.openLinkInSafari(link: "\(Endpoints.explorerBitcoin)/address/\(transaction.toAddress)")
        })
        
        let copyTransactionAction = UIAlertAction(title: Localized.copyTransaction, style: .default, handler: { _ in
            UIPasteboard.general.string = transaction.txid
        })
        
        let copyAddressAction = UIAlertAction(title: Localized.copyAddress, style: .default, handler: { _
            in
            UIPasteboard.general.string = transaction.toAddress
        })
        
        alertController.addAction(viewTransactionAction)
        alertController.addAction(viewAllTransactionsAction)
        alertController.addAction(copyTransactionAction)
        alertController.addAction(copyAddressAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
}

extension TransactionsHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier, for: indexPath) as! TransactionTableViewCell
        
        cell.setTranscation(transactions[indexPath.item])
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.selectedTransaction = transactions[indexPath.row]
        showOptionsForTransaction()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.CELL_HEIGHT
    }
    
}

private struct Localized {
    static var transactions: String { NSLocalizedString("menu_transactions", comment: "") }
    static var viewTranscation: String { NSLocalizedString("View all TX with this address", comment: "") }
    static var viewAllTranscations: String { NSLocalizedString("view_transaction", comment: "") }
    static var copyTransaction: String { NSLocalizedString("copy_transaction", comment: "") }
    static var copyAddress: String { NSLocalizedString("copy_address", comment: "") }
    static var cancel: String { NSLocalizedString("button_cancel", comment: "") }
}

private struct Constants {
    static let CELL_HEIGHT: CGFloat = 80.0
}
