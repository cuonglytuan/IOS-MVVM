//
//  GithubUserCollectionCell.swift
//  GithubUser
//
//  Created by リーツアン クオン on 1/17/20.
//  Copyright © 2020 リーツアン クオン. All rights reserved.
//

import UIKit

class GithubUserCollectionCell: UICollectionViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        disposeBag = DisposeBag()
    }
    
    func compose(with userInfo: GithubUser) {
        if let imageURL = URL(string: userInfo.avatarUrl) {
            userImageView?.af_setImage(withURL: imageURL)
        }
        userNameLabel?.text = userInfo.login
    }
}
