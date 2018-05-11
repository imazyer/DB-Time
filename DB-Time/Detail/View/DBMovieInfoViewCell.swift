//
//  DBMovieInfoViewCell.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/10.
//  Copyright © 2018年 Mazy. All rights reserved.
//

import UIKit
import Cosmos

class DBMovieInfoViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var originalTitleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingStarView: CosmosView!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var collectCountLabel: UILabel!
    @IBOutlet weak var wishCountLabel: UILabel!
    
    func configWithMovie(_ movie: DBMovieSubject) {
        nameLabel.text = movie.title
        originalTitleLabel.text = movie.originalTitle
        var country: String = ""
        if let countries = movie.countries {
            country = countries.map({ " / " + $0 }).reduce("", +)
        }
        descLabel.text = movie.year + country + movie.genres.map({ " / " + $0 }).reduce("", +)
        ratingLabel.text = "\(movie.rating.average)"
        ratingStarView.rating = movie.rating.average / 2
        ratingCountLabel.text = "\(movie.ratingsCount)人评分"
        collectCountLabel.text = "\(movie.collectCount)"
        wishCountLabel.text = "\(movie.wishCount)"
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
