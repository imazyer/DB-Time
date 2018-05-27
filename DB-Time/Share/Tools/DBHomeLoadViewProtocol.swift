//
//  DBHomeLoadViewProtocol.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/27.
//  Copyright © 2018年 Mazy. All rights reserved.
//

import UIKit

protocol DBHomeLoadViewProtocol {
    
}

extension DBHomeLoadViewProtocol where Self : UIViewController {
    
    func showLoadView() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 160, height: 160))
        imageView.layer.cornerRadius = 80
        imageView.loadGif(name: "IMG_6047")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.tag = 1024
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints({
            $0.center.equalToSuperview()
            $0.size.equalTo(CGSize(width: 160, height: 160))
        })
    }
    
    func hideLoadView() {
        view.subviews.filter({ $0.tag == 1024 }).first?.removeFromSuperview()
    }
}
