//
//  RESTManager.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/21/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import UIKit
import Network

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

final class RESTManager: NSObject {
    
    // MARK: - Properties
    static let shared = RESTManager()
    
    // MARK: - Initializer
    private override init() {
        super.init()
    }
    
    // MARK: - Public API
    func GET(from urlString: String, withBody body: Data? = nil, completion: @escaping (Result<Data, Error>) -> Void) {
        guard NetworkManager.shared.isConnected else { return }
        
        guard let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encoded) else {
            fatalError("🛑 URL not in proper format")
        }
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        let request = configureRequest(for: url, method: .get, body: body)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            // Error occured
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                    Logger.log(message: "Error = \(String(describing: error))", type: .error)
                }
            }
            
            // Data acquired
            if let data = data {
                //Logger.log(message: "Data: \(String(describing: String(data: data, encoding: .utf8)))", type: .info)
                
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            } else {
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func POST(from urlString: String, withBody body: Data?, completion: @escaping (Result<Data, Error>) -> Void) {
        guard NetworkManager.shared.isConnected else { return }
        
        guard let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encoded) else {
            fatalError("🛑 URL not in proper format")
        }
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        let request = configureRequest(for: url, method: .post, body: body)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            // Error occured
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                    Logger.log(message: "Error = \(String(describing: error))", type: .error)
                }
            }
            
            // Data acquired
            if let data = data {
                //Logger.log(message: "Data: \(String(describing: String(data: data, encoding: .utf8)))", type: .info)
                
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            } else {
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
        
        task.resume()
    }
    
    // MARK: - Private API
    private func configureRequest(for url: URL, method: HttpMethod, body: Data?) -> URLRequest {
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = body
        
        return request
    }
    
}

extension RESTManager: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if challenge.protectionSpace.host.contains("bitcoin.com") {
                if let trust = challenge.protectionSpace.serverTrust {
                    completionHandler(.useCredential, URLCredential(trust: trust))
                }
            }
        }
    }
    
}
