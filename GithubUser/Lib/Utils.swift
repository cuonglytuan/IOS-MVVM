//
//  Utils.swift
//  GithubUser
//
//  Created by リーツアン クオン on 1/9/20.
//  Copyright © 2020 リーツアン クオン. All rights reserved.
//

import UIKit

import RxSwift
import Moya

func delay(_ interval: Double, dispatchQueue: DispatchQueue = DispatchQueue.main, after: @escaping () -> Void) {
    dispatchQueue.asyncAfter(deadline: .now() + interval, execute: after)
}

func delay(_ interval: Double, task: DispatchWorkItem, dispatchQueue: DispatchQueue = DispatchQueue.main) {
    dispatchQueue.asyncAfter(deadline: .now() + interval, execute: task)
}

func isEqualType(_ left: Any, _ right: Any) -> Bool {
    return typeStr(left) == typeStr(right)
}

func typeStr(_ input: Any) -> String {
    switch Mirror(reflecting: input).displayStyle {
    case .some(.class), .some(.struct), .some(.enum):
        return "\(type(of: input))"
    default:
        return "\(input)"
    }
}

struct Utils {
    
    static func dataFromFile(_ file: String, bundle: Bundle = Bundle.main) -> Data {
        let path = bundle.path(forResource: file, ofType: nil)!
        
        let url = URL(fileURLWithPath: path)
        
        return try! Data(contentsOf: url, options: .uncached)
    }
    
    static func uriEncode(str: String) -> String {
        var allowedCharacterSet = CharacterSet.alphanumerics
        allowedCharacterSet.insert(charactersIn: "-._~")
        return str.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!
    }
}

class TestUtils {
    static var isTesting = false
    static var bundle = Bundle.main
    
    static func dataFromFile(_ file: String) -> Data {
        return Utils.dataFromFile(file, bundle: bundle)
    }
    
    static func errorEndpointClosure() -> (TargetType) -> Moya.Endpoint {
        return { _ in
            Endpoint(url: "http://xxx.com", sampleResponseClosure: { .networkResponse(500, "dummy server error".data(using: .utf8)!) }, method: .get, task: .requestPlain, httpHeaderFields: nil)
        }
    }
}
