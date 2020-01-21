//
//  SecondViewController.swift
//  GithubUser
//
//  Created by リーツアン クオン on 1/7/20.
//  Copyright © 2020 リーツアン クオン. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class SecondViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuTabCollectionView: UICollectionView!
    
    var dataSource: RxCollectionViewSectionedReloadDataSource<GithubUserSectionModel>!
    var menuTabDataSource: RxCollectionViewSectionedReloadDataSource<GithubUserSectionModel>!
    
    var viewModel: GithubUserCollectionViewModel! {
        didSet {
            viewModel.sections.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        }
    }
    
    var menuTabViewModel: MenuTabCollectionViewModel! {
        didSet {
            menuTabViewModel.sections.bind(to: menuTabCollectionView.rx.items(dataSource: menuTabDataSource)).disposed(by: disposeBag)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        collectionView?.contentInsetAdjustmentBehavior = .always
        collectionView.register(UINib(nibName: "GithubUserCollectionCell", bundle: nil), forCellWithReuseIdentifier: "githubusercollection")
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        setupDatasource()
        
        viewModel = GithubUserCollectionViewModel()
        
        menuTabCollectionView?.contentInsetAdjustmentBehavior = .always
        menuTabCollectionView.register(UINib(nibName: "MenuTabCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "menutab")
        
        menuTabCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        menuTabDataSource = RxCollectionViewSectionedReloadDataSource<GithubUserSectionModel>(
            configureCell: { [weak self] menuTabDataSource, collection, idxPath, item in
                guard let `self` = self else { return UICollectionViewCell() }
                let cellUIProvider = menuTabDataSource.sectionModels[idxPath.section].cellUIProvider
                return cellUIProvider.cell(for: collection, indexPath: idxPath, item: item, viewController: self)
            }
        )
        
        menuTabViewModel = MenuTabCollectionViewModel()
        
        viewModel.hasResults
            .subscribe(onNext: { [weak self] hasUser in
                //self?.emptyLabel.isHidden = hasUser
                let isLoading = self?.viewModel.isLoading.value ?? false
                if !isLoading {
                    self?.collectionView.reloadData()
                }
            }).disposed(by: disposeBag)
        
        menuTabViewModel.hasResults
            .subscribe(onNext: { [weak self] hasUser in
                //self?.emptyLabel.isHidden = hasUser
                let isLoading = self?.menuTabViewModel.isLoading.value ?? false
                if !isLoading {
                    self?.menuTabCollectionView.reloadData()
                }
            }).disposed(by: disposeBag)
    }
    
    private func setupDatasource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<GithubUserSectionModel>(
            configureCell: { [weak self] dataSource, collection, idxPath, item in
                guard let `self` = self else { return UICollectionViewCell() }
                let cellUIProvider = dataSource.sectionModels[idxPath.section].cellUIProvider
                return cellUIProvider.cell(for: collection, indexPath: idxPath, item: item, viewController: self)
            }
        )
    }
}

extension SecondViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // swiftlint:disable force_try
        let model = try! dataSource.model(at: indexPath) as! MappableObject
        return dataSource.sectionModels[indexPath.section].cellUIProvider.sizeForItem(collectionView, layout: collectionViewLayout, indexPath: indexPath, item: model, viewController: self)
    }
}


struct MenuTabCellUIProvider: CellUIProvider {
    let heightTabIconCategoryType = CGFloat(10)
    let heightTabIconSearchType = CGFloat(14)
    
    func cell(for collectionView: UICollectionView, indexPath: IndexPath, item: MappableObject, viewController: UIViewController) -> UICollectionViewCell {
        if let userInfo = item as? GithubUser, let vc = viewController as? SecondViewController {
            let vm = vc.viewModel
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menutab", for: indexPath) as! MenuTabCollectionViewCell
            return cell
        }

        return UICollectionViewCell()
        
    }
}

