//
//  Errors.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 3/19/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation

enum QRError: Error {
    case notAbleToGenerateQR
}

extension QRError: LocalizedError {
    
    var localizedDescription: String {
        switch self {
        case .notAbleToGenerateQR:
            return NSLocalizedString("Not able to generate QR code.", comment: "QR Error")
        }
    }
    
}

