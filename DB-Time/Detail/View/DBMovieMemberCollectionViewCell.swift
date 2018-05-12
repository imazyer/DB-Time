//
//  DBMovieMemberCollectionViewCell.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/10.
//  Copyright © 2018年 Mazy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DBMovieMemberCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    
    private var disposeBag = DisposeBag()
    var avatarClickClosure: ((UIButton) -> Void)?
    
    func configWithCast(_ model: DBCastModel) {
        
        avatarButton.setImage(with: URL(string: model.avatars.small))
        nameLabel.text = model.name
        roleLabel.text = model.role
        
        avatarButton.rx.tap.subscribe(onNext: {
            self.avatarClickClosure?(self.avatarButton)
        }).disposed(by: disposeBag)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
