//
//  Logger.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/20/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation

enum LogType: String {
    case error = "[🛑]"
    case info = "[ℹ️]"
    case debug = "[💬]"
    case warning = "[⚠️]"
    case fatal = "[🔥]"
    case success = "[✅]"
}

final class Logger {
    
    // MARK: - Properties
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.locale = .current
        formatter.timeZone = .current
        
        return formatter
    }
    
    // MARK: - Public API
    class func log(message: String,
                   type: LogType,
                   fileName: String = #file,
                   line: Int = #line,
                   column: Int = #column,
                   function: String = #function) {
        
        #if DEBUG
        print("\(Date().formatted()) \(type.rawValue)[\(sourceFileName(filePath: fileName))]: line: \(line), column: \(column) func: \(function) -> \(message)")
        #endif
    }
    
    class func log<T: Codable>(_ object: T) {
        let data = try! JSONEncoder().encode(object)
        let json = String(data: data, encoding: .utf8)
        print("JSON: \(json ?? "")")
    }
    
    // MARK: - Private API
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
}

internal extension Date {
    
    func formatted() -> String {
        return Logger.dateFormatter.string(from: self)
    }
    
}
