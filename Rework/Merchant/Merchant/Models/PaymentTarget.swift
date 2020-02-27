//
//  PaymentTarget.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/25/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation
import BitcoinKit

enum PaymentTargetType {
    case invalid
    case xPub
    case address
    case apiKey
}

final class PaymentTarget {
    
    // MARK: - Properties
    let address: String
    var type: PaymentTargetType
    
    // MARK: - Initializer
    init(address: String, type: PaymentTargetType) {
        self.address = address
        self.type = type
        
        setup()
    }
    
    // MARK: - Private API
    private func setup() {
        if isApiKey() {
            type = .apiKey
        }
        
        if isLegacyAddress() {
            type = .address
        }
    }
    
    private func isApiKey() -> Bool {
        return NSPredicate(format:"SELF MATCHES %@", "[a-z]{40}").evaluate(with: address)
    }
    
    private func isLegacyAddress() -> Bool {
        guard let _ = try? BitcoinAddress(legacy: address) else { return false }
        
        return true
    }
    
    private func isXPub() -> Bool {
        guard let data = Base58.decode(address) else { return false }
        
        let bytes = [UInt8](data)
        
        if bytes.count != 78 {
            return false
        }
        
        let chain = Data(capacity: 32)
        let pub = Data(capacity: 33)
        
        let subdata = data.advanced(by: 41)
        let array = [UInt8](subdata.dropFirst(subdata.count - 1))
        
        if let firstByte = bytes.first {
            if firstByte == 0x02 || firstByte == 0x03 {
                return true
            }
        }
        
        return false
    }
    
}

/**
 
 public boolean isValidXpub(String xpub) {
     try {
         byte[] xpubBytes = Base58.decodeChecked(xpub);
         ByteBuffer byteBuffer = ByteBuffer.wrap(xpubBytes);
         if (byteBuffer.getInt() != 76067358) {
             throw new AddressFormatException("invalid version: " + xpub);
         } else {
             byte[] chain = new byte[32];
             byte[] pub = new byte[33];
             byteBuffer.get();
             byteBuffer.getInt();
             byteBuffer.getInt();
             byteBuffer.get(chain);
             byteBuffer.get(pub);
             ByteBuffer pubBytes = ByteBuffer.wrap(pub);
             int firstByte = pubBytes.get();
             if (firstByte != 2 && firstByte != 3) {
                 throw new AddressFormatException("invalid format: " + xpub);
             } else {
                 return true;
             }
         }
     } catch (Exception var8) {
         return false;
     }
 }
 
 */
