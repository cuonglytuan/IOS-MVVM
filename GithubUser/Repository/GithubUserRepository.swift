//
//  GithubUserRepository.swift
//  GithubUser
//
//  Created by リーツアン クオン on 1/14/20.
//  Copyright © 2020 リーツアン クオン. All rights reserved.
//

import Foundation
import Moya
import RxMoya

import RxSwift
import RxRealm
import RealmSwift

import ObjectMapper

struct GithubUserRepository {
    static var userProvider = MoyaProvider<GithubUserService>(plugins: [ParameterOrderAwarePlugin()])
    
    static func fetchGithubUser(since: Int, pageSize: Int) -> Single<Page> {
        let request = userProvider.rx.request(.get(since: since, pageSize: pageSize))
        return RequestClient.execute(request, GithubUser.self)
            .do(onSuccess: {
                let listUsers = $0
                if since == 0 {
                    let cachedQuestions = githubUser().toArray()
                    MappableObject.markDeletedInApp(cacheObjects: cachedQuestions)
                }
                DatabaseManager.write(listUsers)
            }, onError: { error in
//                if APIErrorHandler.match(error: error, errorCode: .detailDeleted) {
//                    handlErrorQuestionDeleted(qid: qid)
//                }
            })
            .flatMap { response -> Single<Page> in
                return Single<Page>.create { single in
                    single(.success(response.last?.id ?? 0))
                    return Disposables.create()
                }
            }
    }
    
    static func githubUser() -> Results<GithubUser> {
        let users = DatabaseManager.shared.realm.objects(GithubUser.self).filter("isDeleted == false").sorted(byKeyPath: "id", ascending: true)
        return users
    }
    
    static func deleteInvalidated() {
        let deleted = DatabaseManager.shared.realm.objects(GithubUser.self).filter("isDeleted == true")
        DatabaseManager.delete(deleted.toArray())
    }
}
