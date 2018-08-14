//
//  DBMusicViewModel.swift
//  DB-Time
//
//  Created by Mazy on 2018/8/14.
//  Copyright © 2018年 Mazy. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class DBMusicViewModel {
    
    /// ARC & Rx 垃圾回收
    let disposeBag = DisposeBag()
    
    let vmDatas = Variable<[DBMovieSubject]>([])
    
    init() {
        setup()
    }
    
    func setup() {
        DBNetworkProvider.rx.request(.inTheaters)
            .mapObject(DBMovie.self)
            .subscribe(onSuccess: { data in
                // 数据处理
                print(data.subjects)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.vmDatas.value = data.subjects
                })
                
            }, onError: { error in
                print("数据请求失败! 错误原因: ", error)
            }).disposed(by: disposeBag)
    }
}
