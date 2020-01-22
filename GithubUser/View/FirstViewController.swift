//
//  FirstViewController.swift
//  GithubUser
//
//  Created by リーツアン クオン on 1/7/20.
//  Copyright © 2020 リーツアン クオン. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class FirstViewController: UIViewController {
    
    var needsRefreshControl = true
    var needsLoadMore = true
    
    let isRefreshing = BehaviorRelay<Bool>(value: false)
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    var isAnimated = true
    var viewTransition = RxDataSources.ViewTransition.animated
    
    var dataSource: RxTableViewSectionedReloadDataSource<GithubUserSectionModel>!
    var animatedDataSource: RxTableViewSectionedAnimatedDataSource<GithubUserSectionModel>!
    
    var viewModel: GithubUserViewModel! {
        didSet {
            if isAnimated {
                let deleteCommand = tableView.rx.itemDeleted.map(TableViewEditingCommand.deleteItem)
                let movedCommand = tableView.rx.itemMoved.map(TableViewEditingCommand.moveItem)
                Observable.of(deleteCommand, movedCommand).merge().subscribe(onNext: { [weak self] state in
                    self?.viewModel.execute(command: state)
                }).disposed(by: disposeBag)
                viewModel.sections.bind(to: tableView.rx.items(dataSource: animatedDataSource)).disposed(by: disposeBag)
            } else {
                viewModel.sections.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.isEditing = false
        self.tableView.register(UINib(nibName: "GithubUserCell", bundle: nil), forCellReuseIdentifier: "githubuser")
        tableView.register(LoadingTableViewCell.nib(), forCellReuseIdentifier: LoadingTableViewCell.cellID)
        
        setupDatasource()
        
        viewModel = GithubUserViewModel()
        viewModel.hasResults
            .subscribe(onNext: { [weak self] hasUser in
                self?.emptyLabel.isHidden = hasUser
                let isLoading = self?.viewModel.isLoading.value ?? false
                if !isLoading {
                    self?.tableView.reloadData()
                }
            }).disposed(by: disposeBag)
    }
    
    private func setupDatasource() {
        if isAnimated {
            let config = AnimationConfiguration(insertAnimation: .top,
                                                reloadAnimation: .fade,
                                                deleteAnimation: .left)
            animatedDataSource = RxTableViewSectionedAnimatedDataSource<GithubUserSectionModel>(
                animationConfiguration: config,
                decideViewTransition: { _, _, _  in
                    return self.viewTransition
                },
                configureCell: { [weak self] dataSource, table, idxPath, item in
                    guard let `self` = self else { return UITableViewCell() }
                    let cellUIProvider = dataSource.sectionModels[idxPath.section].cellUIProvider
                    return cellUIProvider.cell(for: table, indexPath: idxPath, item: item, viewController: self)
                },
                titleForHeaderInSection: { [weak self] dataSource, section in
                    guard let `self` = self else { return "" }
                    let cellUIProvider = dataSource.sectionModels[section].cellUIProvider
                    return cellUIProvider.titleForHeaderInSection(section, viewController: self)
                },
                canEditRowAtIndexPath: { [weak self] dataSource, idxPath in
                    guard let `self` = self else { return false }
                    let cellUIProvider = dataSource.sectionModels[idxPath.section].cellUIProvider
                    return cellUIProvider.canEditRowAtIndexPath(idxPath, item: dataSource.sectionModels[idxPath.section].items[idxPath.row], viewController: self)
                },
                canMoveRowAtIndexPath: { [weak self] dataSource, idxPath in
                    guard let `self` = self else { return false }
                    let cellUIProvider = dataSource.sectionModels[idxPath.section].cellUIProvider
                    return cellUIProvider.canMoveRowAtIndexPath(idxPath, item: dataSource.sectionModels[idxPath.section].items[idxPath.row], viewController: self)
                }
            )
        } else {
            dataSource = RxTableViewSectionedReloadDataSource<GithubUserSectionModel>(
                configureCell: { [weak self] dataSource, table, idxPath, item in
                    guard let `self` = self else { return UITableViewCell() }
                    let cellUIProvider = dataSource.sectionModels[idxPath.section].cellUIProvider
                    return cellUIProvider.cell(for: table, indexPath: idxPath, item: item, viewController: self)
                },
                titleForHeaderInSection: { [weak self] dataSource, section in
                    guard let `self` = self else { return "" }
                    let cellUIProvider = dataSource.sectionModels[section].cellUIProvider
                    return cellUIProvider.titleForHeaderInSection(section, viewController: self)
                }
            )
        }
    }
    
    func triggerLoadMore() {
        if needsLoadMore {
            viewModel.loadNextPageTrigger.accept(true)
        }
    }
}
