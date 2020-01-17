//
//  ErrorLogger.swift
//  GithubUser
//
//  Created by リーツアン クオン on 1/9/20.
//  Copyright © 2020 リーツアン クオン. All rights reserved.
//

import Foundation

struct ErrorDebugger {
    static func log(_ error: Error?, logToSystemLog: Bool = false) {
        guard let error = error else { return }
                
        if logToSystemLog {
            print(error.localizedDescription)
            return
        }
        debugPrint(error.localizedDescription)
    }
}
