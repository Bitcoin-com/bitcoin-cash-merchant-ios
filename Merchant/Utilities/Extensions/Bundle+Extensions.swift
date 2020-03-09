//
//  Bundle+Extensions.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/20/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation

extension Bundle {
    
    var releaseVersionNumber: String {
        if let text = infoDictionary?["CFBundleShortVersionString"] as? String {
            return text
        }
        
        return ""
    }
    
    var buildVersionNumber: String {
        if let text = infoDictionary?["CFBundleVersion"] as? String {
            return text
        }
        
        return ""
    }
    
}
