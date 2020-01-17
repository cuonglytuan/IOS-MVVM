//
//  EndpointType.swift
//  GithubUser
//
//  Created by リーツアン クオン on 1/14/20.
//  Copyright © 2020 リーツアン クオン. All rights reserved.
//

import Moya

let publicURL = URL(string: "https://api.github.com")!

protocol PublicEndpointType: TargetType {
    var clazz: String { get }
    var entryPoint: String { get }
}

extension PublicEndpointType {
    var baseURL: URL { return publicURL }
    
    var path: String {
        return ""
    }
    var clazz: String {
        fatalError("Abstract class")
    }
    var entryPoint: String {
        fatalError("Abstract class")
    }
    var task: Task {
        fatalError("Abstract class")
    }
    var method: Moya.Method {
        return .get
    }
    var headers: [String: String]? {
        return nil
    }
    var sampleData: Data {
        return Data()
    }
    var validationType: ValidationType {
        return .successCodes
    }
    
    func urlParameters(_ parameters: [String: Any]?, requiresAuth: Bool = false) -> [String: Any] {
        var params = [String: Any]()
        
        if let parameters = parameters {
            params.merge(parameters, uniquingKeysWith: { first, _ in first })
        }
        
        return params
    }
}

class ParameterOrderAwarePlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        if let url = request.url {
            if let urlComps = NSURLComponents(url: url, resolvingAgainstBaseURL: false) {
                if let queryItems = urlComps.queryItems {
                    urlComps.queryItems = parameterOrder(queryItems)
                    
                    var mutableURLRequest = request
                    mutableURLRequest.url = urlComps.url!
                    
                    return mutableURLRequest
                }
            }
        }
        return request
    }
    
    func parameterOrder(_ queryItems: [URLQueryItem]) -> [URLQueryItem] {
        return queryItems.sorted(by: { left, right -> Bool in
            switch (left.name, right.name) {
            case ("class", _):
                return true
            case ("method", "class"):
                return false
            case ("method", _):
                return true
            default:
                return false
            }
        })
    }
}

class IgnoreLocalCachePlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var mutableURLRequest = request
        mutableURLRequest.cachePolicy = .reloadIgnoringLocalCacheData
        return request
    }
}
