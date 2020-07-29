//
//  ItemsView.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/22/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import UIKit

protocol ItemsViewDelegate: class {
    func itemsView(_ itemsView: ItemsView, didTapOnItem item: Item)
}

protocol Item {
    var title: String { get }
    var description: String { get }
    var image: UIImage { get }
}

final class ItemsView: CardView {

    // MARK: - Properties
    private var tableView = UITableView()
    weak var delegate: ItemsViewDelegate?
    var items = [Item]() {
        didSet {
            tableView.reloadData()
        }
    }
    var height: CGFloat {
        return calculateHeight()
    }
    var isScrollEnabled: Bool {
        get {
            return tableView.isScrollEnabled
        }
        set {
            tableView.isScrollEnabled = newValue
        }
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    // MARK: - Public API
    func refresh() {
        tableView.reloadData()
    }
    
    // MARK: - Private API
    private func setupView() {
        backgroundColor = .white
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.accessibilityIdentifier = Tests.ItemsView.tableView
        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: ItemTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = AppConstants.GENERAL_CORNER_RADIUS
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        tableView.contentInsetAdjustmentBehavior = .never
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    private func calculateHeight() -> CGFloat {
        var height =  CGFloat(items.count - 1) * Constants.CELL_HEIGHT
        height += Constants.DESTINATION_CELL_HEIGHT
        return height
    }
    
}

extension ItemsView: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.identifier, for: indexPath) as! ItemTableViewCell
        
        cell.setItem(items[indexPath.item])
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        delegate?.itemsView(self, didTapOnItem: items[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = items[indexPath.row]
        
        if item.title == UserItem.destinationAddress.title {
            return Constants.DESTINATION_CELL_HEIGHT
        }
        
        return Constants.CELL_HEIGHT
    }
    
}

private struct Constants {
    static let XPUB_DESTINATION_CELL_HEIGHT: CGFloat = 100.0
    static let DESTINATION_CELL_HEIGHT: CGFloat = 80.0
    static let CELL_HEIGHT: CGFloat = 65.0
}
