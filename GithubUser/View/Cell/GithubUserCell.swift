//
//  GithubUserCell.swift
//  GithubUser
//
//  Created by リーツアン クオン on 1/15/20.
//  Copyright © 2020 リーツアン クオン. All rights reserved.
//

import Foundation

import UIKit
import RxSwift
import AlamofireImage

class GithubUserCell: UITableViewCell {
    
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func compose(with userInfo: GithubUser) {
        if let imageURL = URL(string: userInfo.avatarUrl) {
            userImageView?.af_setImage(withURL: imageURL)
        }
        userName?.text = userInfo.login

//        xxx.rx.tap.bind(onNext: { [weak self] in
//            xxx.hiding = true
//
//            CATransaction.begin()
//
//            CATransaction.setCompletionBlock({
//                xxxRepository.hide(banner: bannerInfo)
//            })
//
//            self?.tableView?.beginUpdates()
//            self?.tableView?.endUpdates()
//
//            CATransaction.commit()
//        }).disposed(by: disposeBag)
    }
}
