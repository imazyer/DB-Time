//
//  DBPopupMovieTypeView.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/6.
//  Copyright © 2018 Mazy. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class DBPopupMovieTypeView: UIView, TableViewAnimationProtocol {

    private let disposeBag = DisposeBag()
    private var tableView: UITableView!
    private var isShowing: Bool = false
    private var backgroundButton: UIButton!
    // open
    var backClosure: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundButton = UIButton()
        addSubview(backgroundButton)
        backgroundButton.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        backgroundButton.rx.tap.bind { _ in
            self.dismiss()
        }.disposed(by: disposeBag)
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self)
        tableView.backgroundColor = .clear
        tableView.rowHeight = 40
        tableView.isScrollEnabled = false
        tableView.isUserInteractionEnabled = true
        addSubview(tableView)
        
        tableView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.size.equalTo(CGSize(width: 140, height: 40 * 5))
        })
        let items = Observable.just(["正在热映", "即将上映", "Top250", "北美票房榜", "新片榜"])
        
        items.bind(to: tableView.rx.items) { tableView, row, element in
            let cell = tableView.dequeueReusableCell(with: UITableViewCell.self)
            cell.textLabel?.text = element
            cell.selectionStyle = .none
            return cell
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.backClosure?(indexPath.row)
            self?.dismiss()
        }).disposed(by: disposeBag)
    
    }
    
    func show() {
        self.tableView.transform = .identity
        showAnimation(with: .layDown, tableView: tableView)
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.8, animations: {
            self.tableView.frame.size.height = 0
        }) { (_) in
            self.removeFromSuperview()
        }
//        showAnimation(with: .layDownBack, tableView: tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
