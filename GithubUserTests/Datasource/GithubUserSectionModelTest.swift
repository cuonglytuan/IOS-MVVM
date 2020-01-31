//
//  GithubUserSectionModelTest.swift
//  GithubUserTests
//
//  Created by リーツアン クオン on 1/30/20.
//  Copyright © 2020 リーツアン クオン. All rights reserved.
//

import XCTest
import RealmSwift
import XCTest
@testable import GithubUser

class GithubUserSectionModelTest: XCTestCase {
    
    var viewModel: GithubUserSectionModel!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
//        var config = Realm.Configuration()
//        config.inMemoryIdentifier = self.name
//        DatabaseManager.inject(try! Realm(configuration: config))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSectionsFrom() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
