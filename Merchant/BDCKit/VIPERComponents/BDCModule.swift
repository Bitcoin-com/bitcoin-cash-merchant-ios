//
//  BDCModule.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/08.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

protocol BDCModuleDelegate {
    var currentViewController: UIViewController? { get }
    func didPushPreview(_ viewControllerToCommit: UIViewController)
}

protocol BDCModuleBuilder {
    func provide(_ moduleDelegate: BDCModuleDelegate) -> UIView
}

protocol BDCBuilder {
    func provide() -> UIViewController
}
