//
//  DBMusicViewController.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/4.
//  Copyright © 2018 Mazy. All rights reserved.
//

import UIKit

class DBMusicViewController: DBBaseViewController {

    private var tableView: UITableView!
    // ViewModel
    private var viewModel: DBMusicViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init tableView
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell_id")
        view.addSubview(tableView)
        
        viewModel = DBMusicViewModel()
        
        // 将数据绑定到表格
        viewModel.vmDatas.asObservable().do(onNext: { element in
            // dismiss hud
//            print("request Next：", element)
        }).bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_id")!
            cell.textLabel?.text = "\(element.title)"
            print(element)
            cell.accessoryType = .disclosureIndicator
            return cell
            }.disposed(by: disposeBag)
        
        view.backgroundColor = UIColor.random()
        navigationItem.title = "音乐"
        
        let leftBarItemButton = UIButton(type: .system)
        leftBarItemButton.frame.size = CGSize(width: 50, height: 30)
        leftBarItemButton.setImage(#imageLiteral(resourceName: "Category"), for: .normal)
        leftBarItemButton.imageView?.contentMode = .scaleAspectFit
        leftBarItemButton.addTarget(self, action: #selector(leftBarButtonItemDidTap), for: .touchUpInside)
        leftBarItemButton.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarItemButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    @objc func leftBarButtonItemDidTap() {
        if self.menuContainerViewController.sideMenuState == .leftMenuOpen {
            self.menuContainerViewController.setSideMenuState(state: .closed)
        } else {
            self.menuContainerViewController.setSideMenuState(state: .leftMenuOpen)
        }
    }
}
