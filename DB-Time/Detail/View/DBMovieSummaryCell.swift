//
//  DBMovieSummaryCell.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/11.
//  Copyright © 2018年 Mazy. All rights reserved.
//

import UIKit

class DBMovieSummaryCell: UITableViewCell {
    
    private var detailLabel: UILabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        selectionStyle = .none
        
        detailLabel.numberOfLines = 0
        detailLabel.font = UIFont.systemFont(ofSize: 14)
        detailLabel.textColor = UIColor(hexString: "787878")
        self.contentView.addSubview(detailLabel)
        detailLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(12)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-12)
        })
    }
    
    func configWithText(_ text: String?) {
        detailLabel.text = text
        detailLabel.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
