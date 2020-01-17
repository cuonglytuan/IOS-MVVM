//
//  CellDatasource.swift
//  GithubUser
//
//  Created by リーツアン クオン on 1/17/20.
//  Copyright © 2020 リーツアン クオン. All rights reserved.
//

import RxDataSources

protocol CellUIProvider {
    // UITableView datasource
    func cell(for tableView: UITableView, indexPath: IndexPath, item: MappableObject, viewController: UIViewController) -> UITableViewCell
    func heightForRow(_ tableView: UITableView, indexPath: IndexPath, item: MappableObject, viewController: UIViewController) -> CGFloat
    func estimatedHeightForRow(_ tableView: UITableView, indexPath: IndexPath, item: MappableObject, viewController: UIViewController) -> CGFloat
    // UICollectionView datasource
    func cell(for collectionView: UICollectionView, indexPath: IndexPath, item: MappableObject, viewController: UIViewController) -> UICollectionViewCell
    func sizeForItem(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, indexPath: IndexPath, item: MappableObject, viewController: UIViewController) -> CGSize
    // General datasource
    func onItemSelected(indexPath: IndexPath, item: MappableObject, viewController: UIViewController)
    func titleForHeaderInSection(_ section: Int, viewController: UIViewController) -> String?
    func canEditRowAtIndexPath(_ indexPath: IndexPath, item: MappableObject, viewController: UIViewController) -> Bool
    func canMoveRowAtIndexPath(_ indexPath: IndexPath, item: MappableObject, viewController: UIViewController) -> Bool
    func editingStyleRowAtIndexPath(_ indexPath: IndexPath, item: MappableObject, viewController: UIViewController) -> UITableViewCell.EditingStyle
}

extension CellUIProvider {
    // UITableView datasource
    func cell(for tableView: UITableView, indexPath: IndexPath, item: MappableObject, viewController: UIViewController) -> UITableViewCell {
        return UITableViewCell()
    }
    func heightForRow(_ tableView: UITableView, indexPath: IndexPath, item: MappableObject, viewController: UIViewController) -> CGFloat {
        return UITableView.automaticDimension
    }
    func estimatedHeightForRow(_ tableView: UITableView, indexPath: IndexPath, item: MappableObject, viewController: UIViewController) -> CGFloat {
        return heightForRow(tableView, indexPath: indexPath, item: item, viewController: viewController)
    }
    // UICollectionView datasource
    func cell(for collectionView: UICollectionView, indexPath: IndexPath, item: MappableObject, viewController: UIViewController) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    func sizeForItem(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, indexPath: IndexPath, item: MappableObject, viewController: UIViewController) -> CGSize {
        let widthScreen = CGFloat(viewController.view.frame.width)
        let numberTabs = CGFloat(collectionView.numberOfItems(inSection: 0))
        return CGSize(width: widthScreen / 5, height: widthScreen / 5)
    }
    // General datasource
    func onItemSelected(indexPath: IndexPath, item: MappableObject, viewController: UIViewController) {
        debugPrint("onItemSelected: \(self) vc: \(viewController)")
    }
    func titleForHeaderInSection(_ section: Int, viewController: UIViewController) -> String? {
        return nil
    }
    func canEditRowAtIndexPath(_ indexPath: IndexPath, item: MappableObject, viewController: UIViewController) -> Bool {
        return false
    }
    func canMoveRowAtIndexPath(_ indexPath: IndexPath, item: MappableObject, viewController: UIViewController) -> Bool {
        return false
    }
    func editingStyleRowAtIndexPath(_ indexPath: IndexPath, item: MappableObject, viewController: UIViewController) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
