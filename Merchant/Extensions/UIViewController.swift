//
//  UIViewController.swift
//  Merchant
//
//  Created by Eliot Lesar on 5/25/22.
//  Copyright © 2022 Bitcoin.com. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
     internal var windowInterfaceOrientation: UIInterfaceOrientation? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        } else {
            // Fallback on earlier versions
            return UIApplication.shared.statusBarOrientation
        }
    }
    
    internal func valueForOrientation<T>(portraitValue: T, landscapeValue: T, defaultValue: T? = nil) -> T {
        guard let windowInterfaceOrientation = self.windowInterfaceOrientation else { return defaultValue ?? portraitValue }
        
        return windowInterfaceOrientation.isPortrait ? portraitValue : landscapeValue
    }
}
