//
//  GithubUserViewModel.swift
//  GithubUser
//
//  Created by リーツアン クオン on 1/14/20.
//  Copyright © 2020 リーツアン クオン. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

import RealmSwift
import RxRealm

import UIKit

enum TableViewEditingCommand {
    case moveItem(IndexPath, IndexPath)
    case deleteItem(IndexPath)
}

class GithubUserViewModel {
    
    let sections = BehaviorRelay<[GithubUserSectionModel]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: true)
    let disposeBag = DisposeBag()
    
    var nextPage = 1
    var hasNextPage = BehaviorRelay<Bool>(value: true)
    let hasResults = BehaviorRelay<Bool>(value: true)
    
    let loadNextPageTrigger = BehaviorRelay<Bool>(value: true)
    
    
    var userSection: GithubUserSectionModel?
    
    // MARK: - Enum
    enum SectionName: String {
        case user
    }

    func execute(command: TableViewEditingCommand) {
        switch command {
        case .moveItem(let sourceIndexPath, let destinationIndexPath):
            var currentSections = self.sections.value

            let sourceSection = currentSections[sourceIndexPath.section]
            let sourceObjects = sourceSection.objects
            let sourceObject = sourceObjects[sourceIndexPath.row]

            let destinationSection = currentSections[destinationIndexPath.section]
            let destinationObjects = destinationSection.objects
            let destinationObject = destinationObjects[destinationIndexPath.row]

            currentSections[destinationIndexPath.section].objects[destinationIndexPath.row] = sourceObject

            currentSections[sourceIndexPath.section].objects[sourceIndexPath.row] = destinationObject
            
            self.sections.accept(currentSections)

            executeMoveCommand(from: sourceIndexPath, to: destinationIndexPath)

        case .deleteItem(let indexPath):
            let currentSections = self.sections.value
            let section = currentSections[indexPath.section]
            var newObjects = section.objects
            let deletedObject = newObjects[indexPath.row]
            newObjects.remove(at: indexPath.row)
            let newSectionModel = GithubUserSectionModel(objects: newObjects, sectionName: section.sectionName, cellUIProvider: section.cellUIProvider)
            let newSections: [GithubUserSectionModel] = currentSections.enumerated().map { index, section in
                if index == indexPath.section {
                    return newSectionModel
                }
                return section
            }
            self.sections.accept(newSections)
            self.executeDeleteCommand(indexPath: indexPath, deletedObject: deletedObject)
        }
    }

    func executeDeleteCommand(indexPath: IndexPath, deletedObject: MappableObject) {

    }

    func executeMoveCommand(from: IndexPath, to: IndexPath) {

    }
    
    init() {
        
        loadNextPageTrigger
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in self?.loadNextPageIfNecessary() })
            .disposed(by: disposeBag)
        
        let listUser = GithubUserRepository.githubUser()
        
        DatabaseManager.waitUntilWriteTransactionCompletes { [weak self] in
            guard let strongSelf = self else { return }
            Observable.array(from: listUser)
                .subscribe(onNext: { [weak self] user in
                    self?.handleUserChanges(user)
                })
                .disposed(by: strongSelf.disposeBag)
        }
        
        isLoading
            .filter { $0 == false }
            .subscribe(onNext: { [weak self] _ in
                self?.hasResults.accept(!listUser.isEmpty)
            })
            .disposed(by: disposeBag)
    }
    
    func getLoadingObserver() -> PrimitiveSequence<SingleTrait, Page> {
        return GithubUserRepository.fetchGithubUser(since: 0, pageSize: 20)
            .do(onError: { error in

            })
    }
    
    private func handleUserChanges(_ user: [MappableObject]) {
        let questionSection = GithubUserSectionModel(objects: user, sectionName: SectionName.user.rawValue, cellUIProvider: GithubUserTableUIProvider())
        let includeLoading = hasNextPage.value && !user.isEmpty
        let sections = GithubUserSectionModel.sectionsFrom(questionSection, includeLoading: includeLoading)
        self.userSection = questionSection
        hasResults.accept(!user.isEmpty || isLoading.value)
        self.sections.accept(sections)
    }
    
    func loadNextPageIfNecessary() {
        if self.hasNextPage.value && !self.isLoading.value {
            self.load()
        }
    }
    
    func load() {
        isLoading.accept(true)
        
        getLoadingObserver()
            .subscribe(
                onSuccess: { [weak self] nextPage in self?.loadCompleted(with: nextPage) },
                onError: { [weak self] error in self?.loadFailed(with: error) }
            )
            .disposed(by: disposeBag)
    }
    
    func loadCompleted(with nextPage: Int) {
        hasNextPage.accept(nextPage > 0)
        delay(0.15) { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.nextPage = nextPage
            strongSelf.isLoading.accept(false)
        }
    }
    
    func loadFailed(with error: Error) {
        debugPrint("errors \(error)")
        delay(0.15) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.isLoading.accept(false)
        }
    }
    
    func isEmpty() -> Bool {
        let value = sections.value
        return value.isEmpty || value.first!.items.isEmpty
    }
    
    func reload() {
        nextPage = 1
        hasNextPage.accept(true)
        load()
    }
}
