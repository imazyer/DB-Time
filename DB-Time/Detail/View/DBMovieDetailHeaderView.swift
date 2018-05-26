//
//  DBMovieDetailHeaderView.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/10.
//  Copyright © 2018年 Mazy. All rights reserved.
//

import UIKit

class DBMovieDetailHeaderView: UIView {

    @IBOutlet weak var posterImageView: UIImageView!

    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.width * 3 / 4)
        
    }
    
    func setupWithImage(_ avatar: DBAvatar) {
        posterImageView.setImage(with: URL(string: avatar.medium))
    }

}
