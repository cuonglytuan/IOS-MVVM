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
    
    var dataSource: RxCollectionViewSectionedReloadDataSource<GithubUserSectionModel>!
    
    var viewModel: GithubUserCollectionViewModel! {
        didSet {
            viewModel.sections.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
            
//            viewModel.sections.subscribe({ [weak self] _ in
//                guard let strongSelf = self else {
//                    return
//                }
//                let selectedIndex = min(strongSelf.viewModel.selectedIndex.value, strongSelf.viewModel.pages.value.count - 1)
//                strongSelf.viewModel.selectedIndex.accept(selectedIndex)
//            }).disposed(by: disposeBag)
            
//            viewModel.selectedIndex.subscribe(onNext: { [weak self] page in
//                self?.collectionView.reloadData()
//                if let numberOfItems = self?.collectionView.numberOfItems(inSection: 0), page < numberOfItems {
//                    self?.collectionView.scrollToItem(at: IndexPath(row: page, section: 0), at: .centeredHorizontally, animated: true)
//                }
//            }).disposed(by: disposeBag)
//            pageVC?.set(viewModel: viewModel)
//
//            viewModel.isTabsUserInteractionEnabled
//                .subscribe(onNext: { [weak self] isEnable in
//                    self?.collectionView.isScrollEnabled = isEnable
//                })
//                .disposed(by: disposeBag)
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
        
        viewModel.hasResults
            .subscribe(onNext: { [weak self] hasUser in
                //self?.emptyLabel.isHidden = hasUser
                let isLoading = self?.viewModel.isLoading.value ?? false
                if !isLoading {
                    self?.collectionView.reloadData()
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


