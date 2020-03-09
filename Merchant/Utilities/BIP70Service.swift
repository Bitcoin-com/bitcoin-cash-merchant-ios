//
//  BIP70Service.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/21/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation
import UIKit

final class BIP70Service {
    
    // MARK: - Properties
    static let shared = BIP70Service()
    
    // MARK: - Initializer
    private init() {}
    
    // MARK: - Public API
    func createInvoice(_ invoice: InvoiceRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        let body = try? JSONEncoder().encode(invoice)
        
        RESTManager.shared.POST(from: Endpoints.createInvoice, withBody: body) { result in
            completion(result)
        }
    }
    
}
