//
//  GithubUserService.swift
//  GithubUser
//
//  Created by リーツアン クオン on 1/14/20.
//  Copyright © 2020 リーツアン クオン. All rights reserved.
//

import Moya

enum GithubUserService {
    case get(since: Int, pageSize: Int)
}

extension GithubUserService: PublicEndpointType {
    
    var baseURL: URL {
        return publicURL.appendingPathComponent("users")
    }
    
    var clazz: String {
        return "users"
    }
    var entryPoint: String {
        switch self {
        case .get:
            return "get"
        }
    }
    var task: Task {
        switch self {
        case let .get(since, pageSize):
            
            let param: [String: Any] = ["since": since, "per_page": pageSize]
            return .requestParameters(parameters: urlParameters(param), encoding: URLEncoding.queryString)
        }
    }
    var sampleData: Data {
        switch self {
        case .get(_, _):
            return TestUtils.dataFromFile("githubuser.json")
        }
    }
}
