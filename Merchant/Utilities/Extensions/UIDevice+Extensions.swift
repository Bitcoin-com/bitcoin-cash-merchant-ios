//
//  UIDevice+Extensions.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 3/24/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import UIKit

extension UIDevice {
    
    var isPhoneSE: Bool {
        return UIScreen.main.nativeBounds.height == 1136.0
    }
    
}
