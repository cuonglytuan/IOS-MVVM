//
//  GithubUserCellConfiguration.swift
//  GithubUser
//
//  Created by リーツアン クオン on 1/15/20.
//  Copyright © 2020 リーツアン クオン. All rights reserved.
//

import RxDataSources

struct GithubUserTableUIProvider: CellUIProvider {
    
    func cell(for tableView: UITableView, indexPath: IndexPath, item: MappableObject, viewController: UIViewController) -> UITableViewCell {
            if let userInfo = item as? GithubUser,
            let cell = tableView.dequeueReusableCell(withIdentifier: "githubuser", for: indexPath) as? GithubUserCell {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            prepare(cell: cell)
            cell.compose(with: userInfo)
            return cell
        }
        
        return UITableViewCell(style: .default, reuseIdentifier: nil)
    }
    
    func heightForRow(_ tableView: UITableView, indexPath: IndexPath, item: MappableObject, viewController: UIViewController) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func onItemSelected(indexPath: IndexPath, item: MappableObject, viewController: UIViewController) {
        if let info = item as? GithubUser {
            onItemSelected(info: info)
        }
    }
    
    func onItemSelected(info: GithubUser) {
        // override to implement
    }
    
    func prepare(cell: UITableViewCell) {
        // override to implement
    }
    
    func titleForHeaderInSection(_ section: Int, viewController: UIViewController) -> String? {
        return nil
    }
    
    func canEditRowAtIndexPath(_ indexPath: IndexPath, item: MappableObject, viewController: UIViewController) -> Bool {
        return true
    }
    
    func canMoveRowAtIndexPath(_ indexPath: IndexPath, item: MappableObject, viewController: UIViewController) -> Bool {
        return true
    }
    
    func editingStyleRowAtIndexPath(_ indexPath: IndexPath, item: MappableObject, viewController: UIViewController) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
