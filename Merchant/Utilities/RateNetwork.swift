//
//  RateNetwork.swift
//  Merchant
//
//  Copyright © 2019 Jean-Baptiste Dominguez
//  Copyright © 2019 Bitcoin.com
//

import Moya

enum RateNetwork {
    case get
}

extension RateNetwork: TargetType {
    public var baseURL: URL {
        switch self {
        default: return URL(string: "https://markets.api.bitcoin.com/rates?c=BTC")!
        }
    }
    
    public var path: String {
        switch self {
        case .get:
            return ""
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .get: return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        return .requestParameters(parameters: [:], encoding: URLEncoding.default)
    }
    
    public var headers: [String : String]? {
        switch self {
        default:
            return [:]
        }
    }
}
