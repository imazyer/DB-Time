//
//  DBCollectionViewFlowLayout.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/4.
//  Copyright © 2018 Mazy. All rights reserved.
//

import UIKit

class DBCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    var attributes: [UICollectionViewLayoutAttributes]? = [UICollectionViewLayoutAttributes]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        itemSize = CGSize(width: (SCREEN_WIDTH - 40) / 3, height: (SCREEN_WIDTH - 40)/3 + 30)
        minimumLineSpacing = 10
        minimumInteritemSpacing = 10
    }
    
    override func prepare() {
        super.prepare()
        
        let count: Int = collectionView?.numberOfItems(inSection: 0) ?? 0
        
        for i in 0..<count {
            let attris =  getLayoutAttributesForItem(at: IndexPath(row: i, section: 0))
            attributes?.append(attris)
        }
        
    }
    
    func getLayoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        let attris = super.layoutAttributesForItem(at: indexPath)?.copy() as! UICollectionViewLayoutAttributes
        
        guard collectionView != nil else {
            return attris
        }
        
        if indexPath.row%3 == 1 {
            attris.center.y += (SCREEN_WIDTH - 40)/6 + 15
        }
        return attris
    }
    
    /**
     *  返回rect范围内的布局属性
     */
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
}
