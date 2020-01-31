//
//  GithubUserViewModelTest.swift
//  GithubUserTests
//
//  Created by リーツアン クオン on 1/30/20.
//  Copyright © 2020 リーツアン クオン. All rights reserved.
//

import XCTest
import RealmSwift
import RxSwift
import Moya
@testable import GithubUser

class GithubUserViewModelTest: XCTestCase {
    
    var viewModel: GithubUserViewModel!
    var isContinuingTest = true
    var disposeBag: DisposeBag!
    
    let originalProvider = GithubUserRepository.userProvider

    override func setUp() {
        super.setUp()
        
        TestUtils.bundle = Bundle(for: type(of:self))
        TestUtils.isTesting = true
        var config = Realm.Configuration()
        config.inMemoryIdentifier = self.name
        DatabaseManager.inject(try! Realm(configuration: config))
        
        viewModel = GithubUserViewModel()
        disposeBag = DisposeBag()
        
        GithubUserRepository.userProvider = MoyaProvider<GithubUserService>(stubClosure: MoyaProvider.immediatelyStub)
    }

    override func tearDown() {
        disposeBag = nil
        super.tearDown()
        GithubUserRepository.userProvider = originalProvider
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
   
    func test_loadCompleted() {
        
        if !isContinuingTest { return }

        viewModel.loadCompleted(with: 0)
        let filteredSections = viewModel.sections.value.filter { $0.sectionName == LoadingTableViewCell.cellID }
        XCTAssertEqual(filteredSections.count, 0)
    }
    
    func test_loadNextPageIfNecessary() {
        
        if !isContinuingTest { return }

        viewModel.hasNextPage.accept(true)
        viewModel.isLoading.accept(false)
        viewModel.loadNextPageIfNecessary()
    }

    func test_isEmpty() {
        
        if !isContinuingTest { return }

        viewModel.sections.accept([])
        XCTAssertTrue(viewModel.isEmpty())
    }
}
