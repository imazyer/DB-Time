//
//  DBFMCollectionViewCell.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/4.
//  Copyright © 2018 Mazy. All rights reserved.
//

import UIKit

class DBFMCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iconImageView.layer.cornerRadius = (SCREEN_WIDTH - 40)/6
    }

}
