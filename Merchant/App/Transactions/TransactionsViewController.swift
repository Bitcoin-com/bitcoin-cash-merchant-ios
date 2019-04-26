//
//  TransactionsViewController.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2018/11/04.
//  Copyright © 2018 Bitcoin.com. All rights reserved.
//

import UIKit
import RealmSwift

class TransactionsViewController: BDCViewController {
    
    fileprivate let cellId = "transactionCell"
    
    var presenter: TransactionsPresenter?
    var items = [TransactionOutput]()
    
    var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(I_T_TS_TableViewCell.self, forCellReuseIdentifier: cellId)
        view.addSubview(tableView)
        tableView.fillSuperView()
        
        self.tableView = tableView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.viewWillAppear()
    }
    
    func onGetTransactions(_ outputs: [TransactionOutput]) {
        items = outputs
        tableView?.reloadData()
    }
    
}

extension TransactionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let viewAddressAction = UIAlertAction(title: "View address on explorer", style: .default)
        let viewTransactionAction = UIAlertAction(title: "View transaction on explorer", style: .default)
        let copyTransactionAction = UIAlertAction(title: "Copy transaction", style: .default)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(viewAddressAction)
        actionSheet.addAction(viewTransactionAction)
        actionSheet.addAction(copyTransactionAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! I_T_TS_TableViewCell
        let item = items[indexPath.item]
        
        cell.viewCell?.iconImageView.image = UIImage(named: "checkmark_icon")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        cell.viewCell?.iconImageView.tintColor = BDCColor.green.uiColor
        cell.viewCell?.title1Label.text = item.amountInFiat
        cell.viewCell?.title2Label.text = item.amountInBCH
        cell.viewCell?.subtitleLabel.text = item.date
        
        return cell
    }
}
