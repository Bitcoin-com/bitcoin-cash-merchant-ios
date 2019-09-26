//
//  TransactionsViewController.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2018/11/04.
//  Copyright © 2018 Bitcoin.com. All rights reserved.
//

import UIKit
import RealmSwift
import Lottie
import BDCKit

class TransactionsViewController: BDCViewController {
    
    fileprivate let cellId = "transactionCell"
    
    var presenter: TransactionsPresenter?
    var items = [TransactionOutput]()
    
    var tableView: BDCTableView?
    let successAnimation: LOTAnimationView = {
        let animationView = LOTAnimationView(name: "success_animation")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.isHidden = true
        return animationView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = BDCTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BDCTableViewCell<I_T_TS_ViewCell>.self, forCellReuseIdentifier: cellId)
        view.addSubview(tableView)
        tableView.fillSuperView()
        
        view.addSubview(successAnimation)
        successAnimation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        successAnimation.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        successAnimation.widthAnchor.constraint(equalToConstant: 200).isActive = true
        successAnimation.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        self.tableView = tableView
    }
    
    func onGetTransactions(_ outputs: [TransactionOutput]) {
        items = outputs
        tableView?.reloadData()
    }
    
    func onSuccessCopy() {
        successAnimation.isHidden = false
        successAnimation.play { _ in
            self.successAnimation.isHidden = true
        }
    }
    
}

extension TransactionsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let viewAddressAction = UIAlertAction(title: "View address on explorer", style: .default, handler: { _ in
            self.presenter?.didPushViewAddress(forIndex: indexPath.item)
        })
        
        let viewTransactionAction = UIAlertAction(title: "View transaction on explorer", style: .default, handler: { _ in
            self.presenter?.didPushViewTransaction(forIndex: indexPath.item)
        })
        
        let copyTransactionAction = UIAlertAction(title: "Copy transaction", style: .default, handler: { _ in
            self.presenter?.didPushCopyTransaction(forIndex: indexPath.item)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(viewAddressAction)
        actionSheet.addAction(viewTransactionAction)
        actionSheet.addAction(copyTransactionAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? BDCTableViewCell<I_T_TS_ViewCell> else {
            return UITableViewCell()
        }
        let item = items[indexPath.item]
        
        cell.viewCell?.iconImageView.image = UIImage(named: "checkmark_icon")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        cell.viewCell?.iconImageView.tintColor = BDCColor.green.uiColor
        cell.viewCell?.title1Label.text = item.amountInFiat
        cell.viewCell?.title2Label.text = item.amountInBCH
        cell.viewCell?.subtitleLabel.text = item.date
        
        return cell
    }
}
