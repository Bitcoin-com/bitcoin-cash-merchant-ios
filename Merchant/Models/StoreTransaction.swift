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
        if Calendar.current.isDateInToday(date) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "'\(Localized.today)' '\n@ 'HH:mm"
            return dateFormatter.string(from: date)
        } else if Calendar.current.isDateInYesterday(date) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "'\(Localized.yesterday)' '\n@ 'HH:mm"
            return dateFormatter.string(from: date)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE dd MMM '\n@ 'HH:mm"
        
        return dateFormatter.string(from: date)
    }
    
}

private struct Localized {
    static var today: String { NSLocalizedString("today", comment: "") }
    static var yesterday: String { NSLocalizedString("yesterday", comment: "") }
}
