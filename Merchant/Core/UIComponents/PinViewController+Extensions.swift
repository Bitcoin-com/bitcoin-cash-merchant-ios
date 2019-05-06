//
//  PinViewController.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2018/10/18.
//  Copyright © 2018 Bitcoin.com. All rights reserved.
//
import UIKit

protocol PinViewControllerDelegate {
    func onPushPin(_ pin: String)
    func onPushValid()
}

class PinViewController: BDCViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var hasComma = true
    var hasValid = false
    let items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", ",", "0", "del", "valid"]
    let inset: CGFloat = 1
    let minimumLineSpacing: CGFloat = 0
    let minimumInteritemSpacing: CGFloat = 0
    let cellsPerRow = 3
    let cellsPerColumn = 4
    let cellId = "pinCell"
    
    var pinDelegate: PinViewControllerDelegate?
    var pinCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    var commaButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pinCollectionView.register(PinCell.self, forCellWithReuseIdentifier: cellId)
        pinCollectionView.backgroundColor = .clear
        
        pinCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(pinCollectionView)
        
        pinCollectionView.heightAnchor.constraint(equalToConstant: 50*4 + (hasValid ? 80 : 0) + 5 * inset).isActive = true
        
        pinCollectionView.dataSource = self
        pinCollectionView.delegate = self
    }
    
    @objc func didPushValid() {
        pinDelegate?.onPushValid()
    }
    
    @objc func didPushPin(sender: UIButton) {
        guard let pin = sender.currentTitle else {
            return
        }
        
        pinDelegate?.onPushPin(pin)
    }
    
    // Datasource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hasValid ? items.count : items.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PinCell
        
        var item = items[indexPath.item]
        
         if item == "valid" {
            cell.pinButton.setImage(UIImage(named: "checkmark_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
            cell.pinButton.tintColor = BDCColor.green.uiColor
            cell.pinButton.addTarget(self, action: #selector(didPushValid), for: .touchUpInside)
        } else {
            if item == "," {
                if !hasComma {
                    item = ""
                }
                commaButton = cell.pinButton
            }
            cell.pinButton.setTitle(item, for: .normal)
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
        
        if indexPath.item < items.count - 1 || !hasValid {
            let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
            
            return CGSize(width: itemWidth, height: 50)
        } else {
            return CGSize(width: collectionView.bounds.size.width - marginsAndInsets, height: 80)
        }
    }
}
