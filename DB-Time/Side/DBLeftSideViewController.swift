//
//  DBLeftSideViewController.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/3.
//  Copyright © 2018 Mazy. All rights reserved.
//

import UIKit
import Hero
import RxSwift
import RxCocoa

class DBLeftSideViewController: DBBaseViewController {

    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let bgImageView = UIImageView(image: #imageLiteral(resourceName: "background_image"))
        bgImageView.frame = view.bounds
        bgImageView.contentMode = .scaleAspectFill
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bgImageView.addSubview(blurEffectView)
        
        view.addSubview(bgImageView)
        
        // 设置tableView
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.registerNib(DBLeftTableViewCell.self)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 60
        view.addSubview(tableView)
        
        // 顶部视图
        let headerView = UIView.loadFromNibAndClass(DBLeftHeaderView.self)
        headerView?.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 200)
        headerView?.backgroundColor = .clear
        tableView.tableHeaderView = headerView
        
        // tap 手势, headerView 点击
        let tapGesture = UITapGestureRecognizer()
        headerView?.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.subscribe(onNext: { _ in
            print("修改个人信息")
            let navi = DBNavigationController(rootViewController: DBUserInfoViewController())
            navi.hero.isEnabled = true
            self.present(navi, animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        // 初始化数据
        let items = Observable.just(["电影", "读书", "音乐", "FM", "小组"])
        
        // 数据绑定
        items.bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(with: DBLeftTableViewCell.self)
            cell.typeTitleLabel.text = element
            cell.backgroundColor = .clear
            return cell
        }.disposed(by: disposeBag)
        
        // 单元格点击
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            print("点击的cell: \(indexPath.row)")
            
            let navi = self.menuContainerViewController.centerViewController as! DBNavigationController
            let childVC =  navi.viewControllers
            
            self.menuContainerViewController.setSideMenuState(state: .closed, completeBlock: {
                switch indexPath.row {
                case 0:
                    let homeVCs = childVC.filter { $0.isKind(of: DBHomeViewController.self) }
                    guard let homeVC = homeVCs.first as? DBHomeViewController else {
                        navi.setViewControllers([DBHomeViewController()], animated: false)
                        return
                    }
                    navi.setViewControllers([homeVC], animated: false)
                case 1:
                    let fmVCs = childVC.filter { $0.isKind(of: DBFMViewController.self) }
                    guard let fmVC = fmVCs.first as? DBFMViewController else {
                        navi.setViewControllers([DBFMViewController()], animated: false)
                        return
                    }
                    navi.setViewControllers([fmVC], animated: false)
                case 2:
                    let musicVCs = childVC.filter { $0.isKind(of: DBMusicViewController.self) }
                    guard let musicVC = musicVCs.first as? DBMusicViewController else {
                        navi.setViewControllers([DBMusicViewController()], animated: false)
                        return
                    }
                    navi.setViewControllers([musicVC], animated: false)
                default:
                    let homeVCs = childVC.filter { $0.isKind(of: DBHomeViewController.self) }
                    guard let homeVC = homeVCs.first as? DBHomeViewController else {
                        navi.setViewControllers([DBHomeViewController()], animated: false)
                        return
                    }
                    navi.setViewControllers([homeVC], animated: false)
                }
            })
        }).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
