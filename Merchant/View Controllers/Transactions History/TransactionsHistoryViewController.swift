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
    private var noHistoryImageView = UIImageView()
    private var noHistoryLabel = UILabel()
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
        setupNoHistoryImageView()
        setupNoHistoryLabel()
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
    
    private func setupNoHistoryImageView() {
        noHistoryImageView.image = UIImage(imageLiteralResourceName: "notxhistory")
        noHistoryImageView.contentMode = .scaleAspectFit
        noHistoryImageView.clipsToBounds = true
        noHistoryImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noHistoryImageView)
        NSLayoutConstraint.activate([
            noHistoryImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noHistoryImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noHistoryImageView.widthAnchor.constraint(equalToConstant: Constants.NO_HISTORY_IMAGE_VIEW_SIZE),
            noHistoryImageView.heightAnchor.constraint(equalToConstant: Constants.NO_HISTORY_IMAGE_VIEW_SIZE)
        ])
    }
    
    private func setupNoHistoryLabel() {
        noHistoryLabel.textColor = .black
        noHistoryLabel.textAlignment = .center
        noHistoryLabel.numberOfLines = 0
        noHistoryLabel.font = .boldSystemFont(ofSize: Constants.NO_HISTORY_LABEL_FONT_SIZE)
        noHistoryLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noHistoryLabel)
        NSLayoutConstraint.activate([
            noHistoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppConstants.GENERAL_MARGIN),
            noHistoryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppConstants.GENERAL_MARGIN),
            noHistoryLabel.topAnchor.constraint(equalTo: noHistoryImageView.bottomAnchor, constant: Constants.NO_HISTORY_LABEL_TOP_MARGIN)
        ])
    }
    
    private func localize() {
        navigationBar.text = Localized.transactions
        noHistoryLabel.text = Localized.noHistory
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
            AnalyticsService.shared.logEvent(.tx_id_explorer_launched)
            
            self?.openLinkInSafari(link: "\(Endpoints.explorerBitcoin)/tx/\(transaction.txid)")
        })
        
        let viewAllTransactionsAction = UIAlertAction(title: Localized.viewAllTranscations, style: .default, handler: { [weak self] _ in
            AnalyticsService.shared.logEvent(.tx_address_explorer_launched)
            
            self?.openLinkInSafari(link: "\(Endpoints.explorerBitcoin)/address/\(transaction.toAddress)")
        })
        
        let copyTransactionAction = UIAlertAction(title: Localized.copyTransaction, style: .default, handler: { _ in
            AnalyticsService.shared.logEvent(.tx_id_copied)
            
            UIPasteboard.general.string = transaction.txid
        })
        
        let copyAddressAction = UIAlertAction(title: Localized.copyAddress, style: .default, handler: { _
            in
            AnalyticsService.shared.logEvent(.tx_address_copied)
            
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
        noHistoryImageView.isHidden = !transactions.isEmpty
        noHistoryLabel.isHidden = !transactions.isEmpty
        
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
    static var viewTranscation: String { NSLocalizedString("inspect_tx_link_view_transaction", comment: "") }
    static var viewAllTranscations: String { NSLocalizedString("inspect_tx_link_view_all_transactions_with_this_address", comment: "") }
    static var copyTransaction: String { NSLocalizedString("inspect_tx_copy_transaction", comment: "") }
    static var copyAddress: String { NSLocalizedString("inspect_tx_copy_address", comment: "") }
    static var cancel: String { NSLocalizedString("button_cancel", comment: "") }
    static var noHistory: String { NSLocalizedString("no_history_text", comment: "") }
}

private struct Constants {
    static let CELL_HEIGHT: CGFloat = 80.0
    static let NO_HISTORY_IMAGE_VIEW_SIZE: CGFloat = 250.0
    static let NO_HISTORY_LABEL_FONT_SIZE: CGFloat = 20.0
    static let NO_HISTORY_LABEL_TOP_MARGIN: CGFloat = 20.0
}
