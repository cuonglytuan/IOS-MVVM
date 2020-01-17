//
//  NetworkService.swift
//  GithubUser
//
//  Created by リーツアン クオン on 1/14/20.
//  Copyright © 2020 リーツアン クオン. All rights reserved.
//

import RxSwift
import RxCocoa

import Moya
import RxMoya

import Alamofire

import ObjectMapper

typealias Page = Int

private let maxAttempts = 3
private let retryDelay = 0.1

enum RequestError: Error {
    case errorWithRetryAttemptMaxed(underlying: Error)
    case errorWithNoRetry(underlying: Error)
    case errorResponse(underlying: Error)
    case invalidJsonError
    case offline
    case timeout
    case errorWithAuth
    case invalidParameter
}

enum RequestResult {
    case success
    case failed(error: Error?)
}

struct RequestClient {

    static let timeoutLimit = 30.0
    static let offlineTimeoutLimit = 5.0
    
    static let networkManager = Alamofire.NetworkReachabilityManager()
    
    static let networkReachable = BehaviorRelay<Bool>(value: false)
    
    static func startListeningForNetworkStatus() {
        networkManager?.listener = { status in
            switch status {
            case .reachable:
                networkReachable.accept(true)
            default:
                networkReachable.accept(false)
            }
        }
        
        if let manager = networkManager {
            networkReachable.accept(manager.isReachable)
        }
        
        networkManager?.startListening()
        debugPrint("network: started listening")
    }
    
    static func stopListeningForNetworkState() {
        networkManager?.stopListening()
        debugPrint("network: stopped listening")
    }

    static func execute<T: Mappable>(_ request: Single<Response>, _ responseType: T.Type, shouldShowHUD: Bool = true, showHudAfter: Double = 0) -> Single<Array<T>> {
        
        return Single<Array<T>>.create { single in
            RequestQueuetManager.startQueueIfNeed()
            return request
                .do(onSubscribe: {
                })
                .subscribeOn(MainScheduler.instance)
                .retryWhen(retryHandler())
                .timeout(timeoutLimit, scheduler: MainScheduler.instance)
                .subscribe { event in
                    switch event {
                    case let .success(response):
                        debugPrint(response.request!.url!.absoluteString)
                        if let jsonString = try? response.mapString(), let object = Mapper<T>().mapArray(JSONString: jsonString) {
                            single(.success(object))
                        } else {
                            single(.error(RequestError.invalidJsonError))
                        }
                    case let .error(error):
                        let errorClassified = classifyTimeoutError(error: error)
                        single(.error(errorClassified))
                    }
            }
        }.subscribeOn(SerialDispatchQueueScheduler(qos: .default))
    }
    
    static func showHUD(_ shouldShow: Bool, _ requestID: Int, _ after: Double) {
        if shouldShow {
        }
    }
    
    static func hideHUD(_ shouldHide: Bool, _ requestID: Int) {
        if shouldHide {
        }
    }
    
    private static func retryHandler() -> (Observable<Error>) -> Observable<Void> {
        return { error in
            return error.enumerated().flatMap { attempt, error -> Observable<Void> in
                print(error.localizedDescription)
                if !networkReachable.value {
                    debugPrint("retry: waiting for network connection")
                    return networkReachable
                        .filter { $0 }
                        .timeout(offlineTimeoutLimit, other: Observable.just(false), scheduler: MainScheduler.instance)
                        .flatMap { reachable -> Observable<Void> in
                            return reachable ? Observable.just(()) : Observable.error(RequestError.offline)
                        }
                        .take(1)
                }
                
                if let error = shouldErrorOut(attempt, error) {
                    debugPrint("retry: error out with \(error)")
                    return Observable.error(error)
                }
                
                debugPrint("retry: retrying with attempt \(attempt)")
                return Observable<Void>.just(()).delay(retryDelay, scheduler: MainScheduler.instance)
            }
        }
    }
    
    private static func shouldErrorOut(_ attempt: Int, _ error: Error) -> RequestError? {
        if attempt >= maxAttempts {
            return RequestError.errorWithRetryAttemptMaxed(underlying: error)
        }
        
        if let error = error as? MoyaError,
            let response = error.response {
            debugPrint("API ERROR at URL: \(response.request!.url!.absoluteString)")
            
            switch response.statusCode {
            case 401:
                return RequestError.errorWithAuth
            case 400...500, 503:
                return RequestError.errorWithNoRetry(underlying: error)
            default:
                break
            }
        }
        return nil
    }

    static func classifyTimeoutError(error: Error) -> Error {
        switch error {
        case RxError.timeout:
            return networkReachable.value ? RequestError.timeout : RequestError.offline
        default:
            return error
        }
    }
}
