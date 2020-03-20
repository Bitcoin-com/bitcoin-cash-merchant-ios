//
//  CFTimeInterval+Extensions.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 3/20/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation

extension CFTimeInterval {
    
    var formattedTime: String {
        return self >= 1000 ? String(Int(self)) + "s"
            : self >= 1 ? String(format: "%.3gs", self)
            : self >= 1e-3 ? String(format: "%.3gms", self * 1e3)
            : self >= 1e-6 ? String(format: "%.3gµs", self * 1e6)
            : self < 1e-9 ? "0s"
            : String(format: "%.3gns", self * 1e9)
    }
    
}
