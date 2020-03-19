//
//  StoreTransaction.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/22/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation
import RealmSwift

final class StoreTransaction: Object {
    
    // MARK: - Properties
    @objc dynamic var toAddress = ""
    @objc dynamic var txid = ""
    @objc dynamic var amountInSatoshis: Int64 = 0
    @objc dynamic var amountInFiat = ""
    @objc dynamic var date = Date()
    
}

extension StoreTransaction {
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        
        if Calendar.current.isDateInToday(date) {
            dateFormatter.dateFormat = "'\(Localized.today)' '\n@ 'HH:mm"
        } else if Calendar.current.isDateInYesterday(date) {
            dateFormatter.dateFormat = "'\(Localized.yesterday)' '\n@ 'HH:mm"
        } else {
            dateFormatter.dateFormat = "EEE dd MMM '\n@ 'HH:mm"
        }
        
        return dateFormatter.string(from: date)
    }
    
    var formattedDateWithoutNewlines: String {
        let dateFormatter = DateFormatter()
        
        if Calendar.current.isDateInToday(date) {
            dateFormatter.dateFormat = "'\(Localized.today)' HH:mm"
        } else if Calendar.current.isDateInYesterday(date) {
            dateFormatter.dateFormat = "'\(Localized.yesterday)' HH:mm"
        } else {
            dateFormatter.dateFormat = "EEE dd MMM HH:mm"
        }
        
        return dateFormatter.string(from: date)
    }
    
}

private struct Localized {
    static var today: String { NSLocalizedString("Today", comment: "") }
    static var yesterday: String { NSLocalizedString("Yesterday", comment: "") }
}
