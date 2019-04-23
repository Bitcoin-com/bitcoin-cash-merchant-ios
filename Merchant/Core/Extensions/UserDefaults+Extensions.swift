//
//  UserDefaults+Extensions.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/02/26.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import Foundation

extension UserDefaults {
    public static var Merchant: UserDefaults {
        return UserDefaults(suiteName: "Merchant")!
    }
}
