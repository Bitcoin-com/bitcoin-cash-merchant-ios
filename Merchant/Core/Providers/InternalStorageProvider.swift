//
//  UserDefaultStorageProvider.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/03/27.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import Foundation

class InternalStorageProvider {

    func remove(_ key: String) {
        UserDefaults.Merchant.removeObject(forKey: key)
    }
    
    func setString(_ value: String, key: String) {
        UserDefaults.Merchant.set(value, forKey: key)
    }
    
    func getString(_ key: String) -> String? {
        return UserDefaults.Merchant.string(forKey: key)
    }
}
