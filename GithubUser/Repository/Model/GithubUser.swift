//
//  GithubUser.swift
//  GithubUser
//
//  Created by リーツアン クオン on 1/14/20.
//  Copyright © 2020 リーツアン クオン. All rights reserved.
//

import RealmSwift
import ObjectMapper

class GithubUser: MappableObject {
    @objc dynamic var login = ""
    @objc dynamic var avatarUrl = ""
    @objc dynamic var siteAdmin: Bool = false
    @objc dynamic var id: Int = 0
    @objc dynamic var pk = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        login <- map["login"]
        avatarUrl <- map["avatar_url"]
        siteAdmin <- map["site_admin"]
        id <- map["id"]
        
        identity = String(id)
        pk = "\(id)_\(Date().timeIntervalSince1970)"
    }

    override static func primaryKey() -> String? {
        return "pk"
    }
    
    override static func indexedProperties() -> [String] {
        return ["fetchOrder"]
    }
}
