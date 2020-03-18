//
//  URL+Helpers.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 3/18/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation
import UIKit

extension URL {

    var qrImage: CIImage? {
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        
        let qrData = absoluteString.data(using: String.Encoding.ascii)
        qrFilter.setValue(qrData, forKey: "inputMessage")

        let qrTransform = CGAffineTransform(scaleX: 12, y: 12)
        
        return qrFilter.outputImage?.transformed(by: qrTransform)
    }
    
}
