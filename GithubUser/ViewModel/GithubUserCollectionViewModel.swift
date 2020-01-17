//
//  GithubUserCollectionViewModel.swift
//  GithubUser
//
//  Created by リーツアン クオン on 1/16/20.
//  Copyright © 2020 リーツアン クオン. All rights reserved.
//

import RxSwift
import RxCocoa

import RealmSwift
import RxRealm

import UIKit

class GithubUserCollectionViewModel {
    
    let sections = BehaviorRelay<[GithubUserSectionModel]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: true)
    let disposeBag = DisposeBag()
    
    let hasResults = BehaviorRelay<Bool>(value: true)
    
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
        
        let questionSection = GithubUserSectionModel(objects: user, sectionName: SectionName.user.rawValue, cellUIProvider: GithubUserCollectionUIProvider())
        let sections = GithubUserSectionModel.sectionsFrom(questionSection, includeLoading: false)
        self.userSection = questionSection
        hasResults.accept(!user.isEmpty || isLoading.value)
        self.sections.accept(sections)
    }
    
    func isEmpty() -> Bool {
        let value = sections.value
        return value.isEmpty || value.first!.items.isEmpty
    }
}
