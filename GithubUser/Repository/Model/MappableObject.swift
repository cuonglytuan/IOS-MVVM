//
//  MappableObject.swift
//  GithubUser
//
//  Created by リーツアン クオン on 1/9/20.
//  Copyright © 2020 リーツアン クオン. All rights reserved.
//

import RealmSwift
import ObjectMapper
import RxDataSources

class MappableObject: Object, Mappable {
    @objc dynamic var updatedAt: TimeInterval = 0.0
    @objc dynamic var identity = ""
    @objc dynamic var isDeleted = false
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func with(intialObject: Any?) {
        // override to implement
    }
    
    func mapping(map: Map) {
        updatedAt = Date().timeIntervalSince1970
    }
}

func == (lhs: MappableObject, rhs: MappableObject) -> Bool {
    return lhs.updatedAt == rhs.updatedAt
}

extension MappableObject: IdentifiableType {
    typealias Identity = String
}

extension MappableObject {

    static func deleteCacheIfNotFetched(cacheObjects: [MappableObject], fetchObjects: [MappableObject]) {
        cacheLoop: for cache in cacheObjects {
            for fetch in fetchObjects where cache.identity == fetch.identity {
                continue cacheLoop
            }
            markDeletedInApp(cacheObject: cache)
        }
    }

    static func markDeletedInApp(cacheObject: MappableObject) {
        DatabaseManager.transact {
            cacheObject.isDeleted = true
        }
    }

    static func markDeletedInApp(cacheObjects: [MappableObject]) {
        DatabaseManager.transact {
            cacheObjects.forEach { $0.isDeleted = true }
        }
    }
}

class IntToStringTransform: TransformType {
    typealias Object = String
    typealias JSON = Int
    
    init() {}
    func transformFromJSON(_ value: Any?) -> String? {
        if let intValue = value as? Int {
            return "\(intValue)"
        }
        return value as? String
    }
    
    func transformToJSON(_ value: String?) -> Int? {
        if let strValue = value {
            return Int(strValue)
        }
        return nil
    }
}

class Int64Transform: TransformType {
    
    typealias Object = Int64
    typealias JSON = String
    
    init() {}
    func transformFromJSON(_ value: Any?) -> Int64? {
        if let strValue = value as? String {
            return Int64(strValue)
        }
        return value as? Int64
    }
    
    func transformToJSON(_ value: Int64?) -> String? {
        if let intValue = value {
            return "\(intValue)"
        }
        return nil
    }
}

class IntTransform: TransformType {
    
    typealias Object = Int
    typealias JSON = String
    
    init() {}
    func transformFromJSON(_ value: Any?) -> Int? {
        if let strValue = value as? String {
            return Int(strValue)
        }
        return value as? Int
    }
    
    func transformToJSON(_ value: Int?) -> String? {
        if let intValue = value {
            return "\(intValue)"
        }
        return nil
    }
}

class DoubleTransform: TransformType {
    
    typealias Object = Double
    typealias JSON = String
    
    init() {}
    func transformFromJSON(_ value: Any?) -> Double? {
        if let strValue = value as? String {
            return Double(strValue)
        }
        return value as? Double
    }
    
    func transformToJSON(_ value: Double?) -> String? {
        if let value = value {
            return "\(value)"
        }
        return nil
    }
}

class ArrayTransform<T: MappableObject> : TransformType {
    typealias Object = List<T>
    typealias JSON = [AnyObject]
    
    let mapper = Mapper<T>()
    
    let initialObject: Any?
    let filter : ((T) -> Bool)
    
    init (with: Any? = nil, filter: ((T) -> Bool)? = nil) {
        self.initialObject = with
        self.filter = filter ?? { _ in true }
    }
    
    func transformFromJSON(_ value: Any? ) -> List<T>? {
        let result = List<T>()
        if let tempArr = value as? [AnyObject] {
            for entry in tempArr {
                let mapper = Mapper<T>()
                let model: T = mapper.map(JSON: entry as! [String: Any])!
                model.with(intialObject: initialObject)
                
                if filter(model) {
                    result.append(model)
                }
            }
        }
        return result
    }
    
    func transformToJSON(_ value: Object?) -> [AnyObject]? {
        var results = [AnyObject]()
        if let value = value {
            for obj in value {
                let json = mapper.toJSON(obj)
                results.append(json as AnyObject)
            }
        }
        return results
    }
}

class PlaceholderObject: MappableObject {
    var text = ""
    
    required convenience init?(map: Map) {
        fatalError("don't use this initializer!")
    }
    
    convenience init(title: String) {
        self.init()
        self.text = title
    }
}
