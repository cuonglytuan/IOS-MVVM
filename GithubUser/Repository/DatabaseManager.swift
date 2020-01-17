//
//  DatabaseManager.swift
//  GithubUser
//
//  Created by リーツアン クオン on 1/9/20.
//  Copyright © 2020 リーツアン クオン. All rights reserved.
//

import RxRealm
import RealmSwift
import Foundation

private let schemaVersion: UInt64 = 1578589200

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    var realm: Realm
    
    fileprivate init() {
        realm = DatabaseManager.instantiate()
    }
    
    class func realmConfiguration() -> Realm.Configuration {
        return Realm.Configuration(
            schemaVersion: schemaVersion,
            migrationBlock: { migration, oldSchemaVersion in
                debugPrint(migration, oldSchemaVersion)
            },
            shouldCompactOnLaunch: { totalBytes, usedBytes in
                debugPrint("Realm totalBytes:\(totalBytes) usedBytes:\(usedBytes)")
                return false
            }
        )
    }
    
    class func realmPath() -> URL? {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("db.realm")
        return config.fileURL
    }
    
    class func instantiate() -> Realm {
        var configuration = realmConfiguration()
        
        configuration.fileURL = realmPath()
        
        Realm.Configuration.defaultConfiguration = configuration
        
        return try! Realm()
    }

    class func inject(_ realm: Realm) {
        assert(TestUtils.isTesting)
        shared.realm = realm
    }

    class func write(_ objects: Object...) {
        write(objects)
    }
    
    class func write(_ objects: [Object]) {
        transact (objects) { shared.realm.add($0, update: .all) }
    }
        
    class func delete(_ objects: Object...) {
        delete(objects)
    }
    
    class func delete(_ objects: [Object]) {
        transact (objects) { shared.realm.delete($0) }
    }
    
    fileprivate class func transact(_ objects: [Object], operation: @escaping ([Object]) -> Void) {
        if shared.realm.isInWriteTransaction {
            operation(objects)
            return
        }
        do {
            try shared.realm.write {
                operation(objects)
            }
        } catch {
            ErrorDebugger.log(error)
        }
    }
    
    class func transact(operation: () -> Void) {
        if shared.realm.isInWriteTransaction {
            operation()
            return
        }
        do {
            try shared.realm.write {
                operation()
            }
        } catch {
            ErrorDebugger.log(error)
        }
    }
    
    class func waitUntilWriteTransactionCompletes(completion: @escaping () -> Void) {
        if shared.realm.isInWriteTransaction {
            delay(0.1) {
                waitUntilWriteTransactionCompletes {
                    completion()
                }
            }
            return
        }
        completion()
    }
}
