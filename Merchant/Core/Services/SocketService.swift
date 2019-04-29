//
//  SocketService.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/29.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import Foundation
import SwiftWebSocket
import RxSwift

class SocketService {
    
    enum SocketServiceError: Error {
        case decode
    }
    
    struct WebSocketTransactionResponse: Codable {
        var txid: String
        var fees: Int
        var amount: Int
        var outputs: [WebSocketOutputResponse]
    }
    
    struct WebSocketOutputResponse: Codable {
        var address: String
        var value: Int
    }
    
    static let shared = SocketService()

    fileprivate let ws = WebSocket("ws://47.254.143.172:80/v1/address")
    fileprivate var shouldListen = false
    
    var observedAddress: PublishSubject<WebSocketTransactionResponse>?
    
    init() {
        self.ws.event.close = { code, reason, clean in
            self.ws.open()
        }
        
        self.ws.event.error = { error in
            print("error \(error)")
        }
        
        self.ws.event.message = { message in
            let message = message as? String
            let data = message?.data(using: .utf8)
            
            guard let transaction = try? JSONDecoder().decode(WebSocketTransactionResponse.self, from: data!) else {
                return
            }
            
            print("received transaction", transaction)
            
            self.observedAddress?.onNext(transaction)
            
            // Received from the websocket : {"txid":"04dc5f2c5c012ef20de56fde1582139c477f7656de33b1342ed003009eabdf41","fees":0,"confirmations":0,"amount":16983,"outputs":[{"address":"3JL2QfYGqb6jbXNUKVY2RES3exxpRZAi1a","value":16983}]}
        }
        
        self.shouldListen = true
        self.ws.open()
    }
}

extension SocketService {
    
    func observeAddress(withAddress address: String) -> Observable<WebSocketTransactionResponse> {
        guard let observedAddress = self.observedAddress else {
            let observedAddress = PublishSubject<WebSocketTransactionResponse>()
            self.observedAddress = observedAddress
            self.subscribe(withAddress: address)
            return observedAddress.asObservable()
        }
        
        self.subscribe(withAddress: address)
        return observedAddress.asObservable()
    }
    
    func subscribe(withAddress address: String) {
        let message = "{\"op\": \"addr_sub\", \"addr\":\"\(address)\"}"
        self.ws.send(message)
    }
}
