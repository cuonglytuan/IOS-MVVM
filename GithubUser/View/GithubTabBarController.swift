//
//  GithubTabBarController.swift
//  GithubUser
//
//  Created by リーツアン クオン on 1/21/20.
//  Copyright © 2020 リーツアン クオン. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GithubTabBarController: UITabBarController {
    
    static var shared = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() as! GithubTabBarController
    
    let disposeBag = DisposeBag()
    let loaded = BehaviorRelay<Bool>(value: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lineImage = UIImage(named: "centreImage")!
        let frame = tabBar.frameWithCenteredX(with: lineImage.size)
        let lineButton = UIButton(frame: frame)
        lineButton.translatesAutoresizingMaskIntoConstraints = false
        lineButton.setBackgroundImage(lineImage, for: .normal)
        lineButton.setBackgroundImage(lineImage, for: .highlighted)
        
        tabBar.addSubview(lineButton)
        
        tabBar.isTranslucent = false
        
        lineButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor).isActive = true
        lineButton.topAnchor.constraint(equalTo: tabBar.topAnchor).isActive = true
        
        loaded.accept(true)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
    }
}
