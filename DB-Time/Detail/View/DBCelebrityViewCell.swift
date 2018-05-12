//
//  DBCelebrityViewCell.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/12.
//  Copyright © 2018年 Mazy. All rights reserved.
//

import UIKit

class DBCelebrityViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameEnLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var bornPlaceLabel: UILabel!
    
    func configWithCelebrity(_ model: DBCelebrityModel) {
        avatarImageView.setImage(with: URL(string: model.avatars.small))
        nameLabel.text = model.name
        nameEnLabel.text = model.nameEN
        genderLabel.text = model.gender
        nicknameLabel.text = model.aka.map({ "/" + $0 }).reduce("", +)
        roleLabel.text = model.works.first?.roles.first
        bornPlaceLabel.text = model.bornPlace
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
