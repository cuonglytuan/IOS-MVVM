//
//  GithubUserCollectionCellConfiguration.swift
//  GithubUser
//
//  Created by リーツアン クオン on 1/16/20.
//  Copyright © 2020 リーツアン クオン. All rights reserved.
//

import RxDataSources

struct GithubUserCollectionUIProvider: CellUIProvider {
    func cell(for collectionView: UICollectionView, indexPath: IndexPath, item: MappableObject, viewController: UIViewController) -> UICollectionViewCell {
            if let userInfo = item as? GithubUser,
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "githubusercollection", for: indexPath) as? GithubUserCollectionCell {
//            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
//            prepare(cell: cell)
            cell.compose(with: userInfo)
                cell.backgroundColor = UIColor.red
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func sizeForItem(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, indexPath: IndexPath, item: MappableObject, viewController: UIViewController) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
}
