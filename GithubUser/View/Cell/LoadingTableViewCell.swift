//
//  LoadingTableViewCell.swift
//  GithubUser
//
//  Created by リーツアン クオン on 1/22/20.
//  Copyright © 2020 リーツアン クオン. All rights reserved.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {
    
    static let cellID = "Loading"
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    static func nib() -> UINib {
        return UINib(nibName: "LoadingTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        indicatorView.startAnimating()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
class LoadingCellUIProvider: CellUIProvider {
    func onItemSelected(indexPath: IndexPath, item: MappableObject, viewController: UIViewController) {
        debugPrint("")
    }

    func cell(for tableView: UITableView, indexPath: IndexPath, item: MappableObject, viewController: UIViewController) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.cellID) {
            if let paginatingTableView = viewController as? FirstViewController {
                paginatingTableView.triggerLoadMore()
            }
            
            return cell
        }

        fatalError("check tableview.registerNib")
    }

}
