//
//  PinViewController.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2018/10/18.
//  Copyright © 2018 Bitcoin.com. All rights reserved.
//
import UIKit

protocol PinViewControllerDelegate {
    func onPushPin(amount: String)
    func onPushValid(amount: String)
}

class PinViewController: BDCViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", ",", "0", "del", "valid"]
    let inset: CGFloat = 1
    let minimumLineSpacing: CGFloat = 0
    let minimumInteritemSpacing: CGFloat = 0
    let cellsPerRow = 3
    let cellsPerColumn = 4
    let cellId = "pinCell"
    
    var amount: Int = 0
    var amountStr: String = "0"
    var pinDelegate: PinViewControllerDelegate?
    var pinCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pinCollectionView.register(PinCell.self, forCellWithReuseIdentifier: cellId)
        pinCollectionView.backgroundColor = BDCColor.white.uiColor
        
        pinCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(pinCollectionView)
        
        pinCollectionView.heightAnchor.constraint(equalToConstant: 50*4 + 80 + 5 * inset).isActive = true
        
        pinCollectionView.dataSource = self
        pinCollectionView.delegate = self
    }
    
    @objc func didPushValid() {
        pinDelegate?.onPushValid(amount: amountStr)
    }
    
    @objc func didPushPin(sender: UIButton) {
        guard let pin = sender.currentTitle else {
            return
        }
        
        switch pin {
        case ",":
            if amountStr.contains(pin) {
                return
            }
            amountStr.append(pin)
            pinDelegate?.onPushPin(amount: amountStr)
        case "del":
            if amountStr.count > 1 {
                amountStr.removeLast()
            } else {
                amountStr = "0"
            }
            pinDelegate?.onPushPin(amount: amountStr)
        default:
            if amountStr.count < 1 || amountStr == "0" {
                amountStr = pin
            } else {
                amountStr.append(pin)
            }
            pinDelegate?.onPushPin(amount: amountStr)
        }
    }
    
    // Datasource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PinCell
        
        let item = items[indexPath.item]
        
        if item == "valid" {
            cell.pinButton.setImage(UIImage(named: "checkmark_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
            cell.pinButton.tintColor = BDCColor.green.uiColor
            cell.pinButton.addTarget(self, action: #selector(didPushValid), for: .touchUpInside)
        } else {
            cell.pinButton.setTitle(items[indexPath.item], for: .normal)
            cell.pinButton.addTarget(self, action: #selector(didPushPin), for: .touchUpInside)
        }
        
        return cell
    }
}

extension PinViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let marginsAndInsets = inset * 2 + minimumInteritemSpacing * CGFloat(cellsPerRow)
        
        if indexPath.item < items.count - 1 {
            let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
            
            return CGSize(width: itemWidth, height: 50)
        } else {
            return CGSize(width: collectionView.bounds.size.width - marginsAndInsets, height: 80)
        }
    }
}
