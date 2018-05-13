//
//  DBCastViewController.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/12.
//  Copyright © 2018年 Mazy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class DBCastViewController: DBBaseViewController {

    var castModel: DBCastModel?
    private var tableView: UITableView!
    private var headerView = UIView.loadFromNibAndClass(DBCelebrityHeaderView.self)!
    var celebrityModel: DBCelebrityModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.registerNib(DBWorkTableViewCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionFooterHeight = 0.001
        tableView.sectionHeaderHeight = 35
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
 
        getCelebrityDetail(castModel?.id)
        
        guard let cast = castModel else { return }
        
        navigationItem.title = cast.name
        
        let headerViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 200/375 * SCREEN_WIDTH))
        headerViewContainer.backgroundColor = .red
        headerViewContainer.addSubview(headerView)
        headerView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        headerView.configWithCast(cast)
        tableView.tableHeaderView = headerViewContainer
    }
    
    func bindData(_ user: DBCelebrityModel) {
        let items = Observable.just([
                SectionModel(model: "影视作品", items: Array(0..<user.works.count))
            ])
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>>(configureCell: { (dataSource, tableView, indexPath, index) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(with: DBWorkTableViewCell.self)
            cell.configWithWork(user.works[indexPath.row])
            return cell
        }, titleForHeaderInSection: { dataSource, sectionIndex in
            return dataSource[sectionIndex].model
        })
        
        items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            guard let celebrity = self.celebrityModel, let movie = celebrity.works[indexPath.row].movie else {
                return
            }
            let movieDetailVC = DBMovieDetailViewController()
            movieDetailVC.movieSubject = movie
            self.navigationController?.show(movieDetailVC, sender: nil)
        }).disposed(by: disposeBag)
        
        // 设置代理
//        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    func getCelebrityDetail(_ id: String?) {
        guard let id = id else { return }
        DBNetworkProvider.rx.request(.celebrityDetail(id))
            .mapObject(DBCelebrityModel.self)
            .subscribe(onSuccess: { [weak self] celebrity in
                // 数据处理
                self?.celebrityModel = celebrity
                self?.headerView.configWithCelebrity(celebrity)
                self?.bindData(celebrity)
                }, onError: { error in
                    print("数据请求失败! 错误原因: ", error)
            }).disposed(by: disposeBag)
    }
}


