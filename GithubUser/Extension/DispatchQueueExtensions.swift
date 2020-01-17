//
//  DispatchQueueExtensions.swift
//  GithubUser
//
//  Created by リーツアン クオン on 1/14/20.
//  Copyright © 2020 リーツアン クオン. All rights reserved.
//

import Foundation

extension DispatchQueue {
    class func mainSync(execute method: () -> Void) {
        if Thread.isMainThread {
            method()
        } else {
            DispatchQueue.main.sync(execute: method)
        }
    }
}
