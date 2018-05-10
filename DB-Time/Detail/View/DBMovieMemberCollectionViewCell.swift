//
//  DBMovieMemberCollectionViewCell.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/10.
//  Copyright © 2018年 Mazy. All rights reserved.
//

import UIKit

class DBMovieMemberCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    
    func configWithCast(_ model: DBCastModel) {
        
        avatarImageView.setImage(with: URL(string: model.avatars.small))
        nameLabel.text = model.name
        roleLabel.text = model.role
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
