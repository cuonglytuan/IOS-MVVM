//
//  GithubUserSection.swift
//  GithubUser
//
//  Created by リーツアン クオン on 1/15/20.
//  Copyright © 2020 リーツアン クオン. All rights reserved.
//

import Foundation
import RxDataSources

struct GithubUserSectionModel: Equatable {
    typealias SectionName = String
    
    var objects: [MappableObject]
    var sectionName: SectionName
    var cellUIProvider: CellUIProvider
}

func == (lhs: GithubUserSectionModel, rhs: GithubUserSectionModel) -> Bool {
    return lhs.sectionName == rhs.sectionName && lhs.items == rhs.items
}

extension GithubUserSectionModel: AnimatableSectionModelType {
    typealias Item = MappableObject
    typealias Identity = String
    
    var identity: String {
        return sectionName
    }
    
    var items: [MappableObject] {
        return objects
    }
    
    init(original: GithubUserSectionModel, items: [Item]) {
        self = original
        self.objects = items
    }
    
    static func sectionsFrom(_ sectionModels: GithubUserSectionModel..., includeLoading: Bool) -> [GithubUserSectionModel] {
        var sections = [GithubUserSectionModel](sectionModels)
        
//        if includeLoading {
//            sections.append(loadingSectionModel())
//        }
        return sections
    }
}
