//
//  DBMoiveDetailViewController.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/5.
//  Copyright © 2018 Mazy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DBMoiveDetailViewController: DBBaseViewController {
    /// ARC & Rx 垃圾回收
    private let disposeBag = DisposeBag()
    private var tableView: UITableView!
    private var headerView = UIView.loadFromNibAndClass(DBMovieDetailHeaderView.self)!
    
    var detailModel: DBMovieSubject?
    
    var movie: DBMovieSubject? {
        didSet {
            headerView.setupWithImage(movie!.images)
            tableView.reloadData()
            
            getMovieDetail(movie!.id)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.layoutIfNeeded()
        
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.register(DBMovieSummaryCell.self)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionFooterHeight = 0.001
        
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        tableView.tableHeaderView = headerView
        
        tableView.reloadData()
        
    }
    
    func getMovieDetail(_ id: String) {
        DBNetworkProvider.rx.request(.movieDetail(id))
            .mapObject(DBMovieSubject.self)
            .subscribe(onSuccess: { [weak self] data in
                // 数据处理
                self?.detailModel = data
                self?.tableView.reloadData()
            }, onError: { error in
                print("数据请求失败! 错误原因: ", error)
            }).disposed(by: disposeBag)
    }
}

extension DBMoiveDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.001 : 34
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "" : "剧情简介"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(with: DBMovieSummaryCell.self)
            cell.configWithText(movie?.title)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(with: DBMovieSummaryCell.self)
            cell.configWithText(detailModel?.summary)
            return cell
        }
    }
}

class DBMovieSummaryCell: UITableViewCell {
    
    private var detailLabel: UILabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        selectionStyle = .none
        
        detailLabel.numberOfLines = 0
        detailLabel.font = UIFont.systemFont(ofSize: 14)
        detailLabel.textColor = UIColor(hexString: "787878")
        self.contentView.addSubview(detailLabel)
        detailLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(12)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-12)
        })
    }
    
    func configWithText(_ text: String?) {
        detailLabel.text = text
        detailLabel.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



