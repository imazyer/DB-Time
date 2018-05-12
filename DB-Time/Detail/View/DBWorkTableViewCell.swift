//
//  DBWorkTableViewCell.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/12.
//  Copyright © 2018年 Mazy. All rights reserved.
//

import UIKit
import Cosmos

class DBWorkTableViewCell: UITableViewCell {

    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starView: CosmosView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var rolesLabel: UILabel!
    
    func configWithWork(_ model: DBWorkModel) {
        postImageView.setImage(with: URL(string: model.movie.images.small))
        nameLabel.text = model.movie.title
        starView.rating = model.movie.rating.average / 2
        ratingLabel.text = "\(model.movie.rating.average)"
        descLabel.text = model.movie.year + "xxxx"
        membersLabel.text = model.movie.directors.first?.name 
        rolesLabel.text = model.roles.first
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
