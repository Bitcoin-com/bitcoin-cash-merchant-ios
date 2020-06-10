//
//  UserDefaults+Extensions.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/23/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    public static var merchant: UserDefaults {
        return UserDefaults(suiteName: "Merchant")!
    }
    
}
