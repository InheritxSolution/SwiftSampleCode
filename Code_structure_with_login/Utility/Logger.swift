//
//  Logger.swift
//  Inheritx Solutions
//

import Foundation
import os.log

enum LogCategory: String {
    case network = "Network"
    case ui = "UI"
    case auth = "Authentication"
    case general = "General"
}

class AppLogger {
    static let shared = AppLogger()
    
    private init() {}
    
    func log(_ message: String, category: LogCategory = .general, type: OSLogType = .default) {
        #if DEBUG
        let log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.inheritx.SwiftSampleCode", category: category.rawValue)
        os_log("%{public}@", log: log, type: type, message)
        #endif
    }
    
    func error(_ message: String, category: LogCategory = .general) {
        log(message, category: category, type: .error)
    }
    
    func debug(_ message: String, category: LogCategory = .general) {
        log(message, category: category, type: .debug)
    }
}
