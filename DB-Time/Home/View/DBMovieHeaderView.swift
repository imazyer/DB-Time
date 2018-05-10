//
//  DBMovieHeaderView.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/5.
//  Copyright © 2018 Mazy. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class DBMovieHeaderView: UIView {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let disposeBag = DisposeBag()
    
    var castModels: Observable<[DBCastModel]>? {
        didSet{
            castModels?.bind(to: collectionView.rx.items) { collectionView, row, model in
                let cell = collectionView.dequeueReusableCell(with: DBMovieHeaderViewCell.self, for: IndexPath(item: row, section: 0))
                cell.setupWithImageCast(model)
                return cell
                }.disposed(by: disposeBag)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        flowLayout.minimumLineSpacing = 1
        
        collectionView.isPagingEnabled = true
        collectionView.register(DBMovieHeaderViewCell.self)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        flowLayout.itemSize = CGSize(width: (bounds.size.width - 2) / 3, height: bounds.size.height)
    }
}


class DBMovieHeaderViewCell: UICollectionViewCell {
    
    private var photoImageView: UIImageView = UIImageView()
    private var bottomContainerView: UIView = UIView()
    private var actorNameLabel: UILabel =  UILabel()
    
    func setupWithImageCast(_ cast: DBCastModel) {
//        photoImageView.setImage(with: URL(string: cast.avatars.medium))
        actorNameLabel.text = cast.name
        actorNameLabel.sizeToFit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        photoImageView.clipsToBounds = true
        photoImageView.contentMode = .scaleAspectFill
        contentView.addSubview(photoImageView)
        photoImageView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        bottomContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        contentView.addSubview(bottomContainerView)
        bottomContainerView.snp.makeConstraints({
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(20)
        })
        
        actorNameLabel.textColor = UIColor.white
        actorNameLabel.textAlignment = .center
        actorNameLabel.font = UIFont.systemFont(ofSize: 12)
        bottomContainerView.addSubview(actorNameLabel)
        actorNameLabel.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
