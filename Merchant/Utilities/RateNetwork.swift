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
    // New BCH-denominated prices endpoint (mirrors Android's BuildConfig.PRICES_URL).
    // Response format: { "rates": [ { "ccy": "usd", "rate": <fiat per 1 BCH>, ... } ] }
    // The URL is confidential and lives in the gitignored `Keys.swift`
    // (copy `Keys.example.swift` -> `Keys.swift` and fill in the real value).
    public var baseURL: URL {
        switch self {
        default: return URL(string: Keys.pricesURL)!
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
