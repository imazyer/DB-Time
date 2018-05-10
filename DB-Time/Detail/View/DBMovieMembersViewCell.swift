//
//  DBMovieMembersViewCell.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/10.
//  Copyright © 2018年 Mazy. All rights reserved.
//

import UIKit

class DBMovieMembersViewCell: UITableViewCell {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    private var castModels: [DBCastModel] = []
    
    func configWithCasts(_ casts: [DBCastModel]) {
        castModels = casts
        collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        collectionView.dataSource = self
        collectionView.delegate = self
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


extension DBMovieMembersViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return castModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: DBMovieMemberCollectionViewCell.self, for: indexPath)
        cell.configWithCast(castModels[indexPath.row])
        return cell
    }
}
