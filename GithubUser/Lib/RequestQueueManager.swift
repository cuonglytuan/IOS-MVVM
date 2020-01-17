//
//  RequestQueueManager.swift
//  GithubUser
//
//  Created by リーツアン クオン on 1/14/20.
//  Copyright © 2020 リーツアン クオン. All rights reserved.
//
import Foundation

struct RequestQueuetManager {

    static let queueRequestTimeoutLimit = 10.0

    private static var shouldQueueRequest = true

    private(set) static var queueRequestArray = [DispatchSemaphore]()

    static func startQueue() {
        set(shouldQueueRequest: true)
    }

    static func endQueue() {
        set(shouldQueueRequest: false)
        signalAndRemoveAll()
    }

    private static func set(shouldQueueRequest: Bool) {
        DispatchQueue.mainSync {
            RequestQueuetManager.shouldQueueRequest = shouldQueueRequest
        }
    }

    static func startQueueIfNeed() {
        if shouldQueueRequest {
            let semaphore = DispatchSemaphore(value: 0)
            append(semaphore)
            let result = semaphore.wait(timeout: .now() + queueRequestTimeoutLimit)
            if result == .timedOut {
                set(shouldQueueRequest: false)
                remove(semaphore)
            }
        }
    }

    static func append(_ semaphore: DispatchSemaphore) {
        DispatchQueue.mainSync {
            queueRequestArray.append(semaphore)
        }
    }

    static func remove(_ semaphore: DispatchSemaphore) {
        DispatchQueue.mainSync {
            if let index = queueRequestArray.firstIndex(where: { $0 == semaphore }) {
                queueRequestArray.remove(at: index)
            }
        }
    }

    static func signalAndRemoveAll() {
        DispatchQueue.mainSync {
            queueRequestArray.forEach { $0.signal() }
            queueRequestArray.removeAll()
        }
    }
}
