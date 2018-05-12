//
//  DBMovieMembersViewCell.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/10.
//  Copyright © 2018年 Mazy. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class DBMovieMembersViewCell: UITableViewCell {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let disposeBag = DisposeBag()
    var avatarClickClosure: (() -> Void)?
    
    func configWithCasts(_ casts: [DBCastModel]) {
        
        collectionView.delegate = nil
        collectionView.dataSource = nil
        
        let items = Observable.just(casts)
        
        items.bind(to: collectionView.rx.items){ [weak self] (collectionView, row, cast) in
            let indexPath = IndexPath(item: row, section: 0)
            let cell = collectionView.dequeueReusableCell(with: DBMovieMemberCollectionViewCell.self, for: indexPath)
            cell.avatarClickClosure = { [weak self] in
                self?.avatarClickClosure?()
            }
            cell.configWithCast(cast)
            return cell
        }.disposed(by: disposeBag)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        collectionView.contentInset = UIEdgeInsetsMake(0, 16, 0, 16)
        collectionView.registerNib(DBMovieMemberCollectionViewCell.self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = bounds.height * 0.618
        let height: CGFloat = bounds.height
        flowLayout.itemSize = CGSize(width: width, height:height)
        flowLayout.minimumLineSpacing = 10
    }
}

