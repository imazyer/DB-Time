//
//  DBCelebrityHeaderView.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/13.
//  Copyright © 2018年 Mazy. All rights reserved.
//

import UIKit

class DBCelebrityHeaderView: UIView {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameEnLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var bornPlaceLabel: UILabel!
    
    func configWithCast(_ model: DBCastModel) {
        avatarImageView.hero.id = "avatar_id\(model.id)"
        if let avatar = model.avatars?.small {
            avatarImageView.setImage(with: URL(string: avatar))
        }
        nameLabel.text = model.name
        roleLabel.text = "职业: " + model.role
    }
    
    func configWithCelebrity(_ model: DBCelebrityModel) {
        
        nameEnLabel.text = model.nameEN
        genderLabel.text = "性别: " + model.gender
        var askString = "昵称: "
        for (i, title) in model.aka.enumerated() {
            askString += title
            if i < model.aka.count - 1 {
                askString += " / "
            }
        }
        nicknameLabel.text = askString
        
        var roles: [String] = []
        for role in model.works {
            for ro in role.roles {
                if !roles.contains(ro) {
                    roles.append(ro)
                }
            }
        }
        
        var rolesString = "职业: "
        for (i, role) in roles.enumerated() {
            rolesString += role
            if i < roles.count - 1 {
                rolesString += " / "
            }
        }
        
        roleLabel.text = rolesString
        bornPlaceLabel.text = "出生地: " + model.bornPlace
    }
}
