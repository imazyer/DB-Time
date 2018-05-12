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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.registerNib(DBCelebrityViewCell.self)
        tableView.registerNib(DBWorkTableViewCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionFooterHeight = 0.001
        tableView.contentInset.top = -20
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
 
        navigationItem.title = castModel?.name
        
        getCelebrityDetail(castModel?.id)
        
    }
    
    func bindData(_ user: DBCelebrityModel) {
        
        let items = Observable.just([
                SectionModel(model: "", items: [0]),
                SectionModel(model: "影视作品", items: Array(0..<user.works.count))
            ])
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>>(configureCell: { (dataSource, tableView, indexPath, index) -> UITableViewCell in
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(with: DBCelebrityViewCell.self)
                cell.avatarImageView.hero.id = "avatar_id\(self.castModel?.id ?? "")"
                cell.configWithCelebrity(user)
                return cell
            default:
                let cell = tableView.dequeueReusableCell(with: DBWorkTableViewCell.self)
                cell.configWithWork(user.works[indexPath.row])
                return cell

            }
        }, titleForHeaderInSection: { dataSource, sectionIndex in
            return dataSource[sectionIndex].model
        })
        
        items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    func getCelebrityDetail(_ id: String?) {
        guard let id = id else { return }
        DBNetworkProvider.rx.request(.celebrityDetail(id))
            .mapObject(DBCelebrityModel.self)
            .subscribe(onSuccess: { [weak self] celebrity in
                // 数据处理
                self?.bindData(celebrity)
                }, onError: { error in
                    print("数据请求失败! 错误原因: ", error)
            }).disposed(by: disposeBag)
    }
}

extension DBCastViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 35 : 0.0001
    }
}

