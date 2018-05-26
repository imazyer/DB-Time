//
//  UIImageView+URL.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/4.
//  Copyright © 2018 Mazy. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(with url: URL?,
                  placeholder: Placeholder? = nil,
                  options: KingfisherOptionsInfo = [.transition(.fade(0.2))],
                  progressBlock: DownloadProgressBlock? = nil,
                  completionHandler: CompletionHandler? = nil) {
        kf.indicatorType = .activity
        kf.setImage(with: url,
                    placeholder: placeholder,
                    options: options,
                    progressBlock: progressBlock,
                    completionHandler: completionHandler)
    }
}

extension UIButton {
    
    func setImage(with url: URL?,
                  placeholder: UIImage? = nil,
                  options: KingfisherOptionsInfo = [.transition(.fade(0.2))],
                  progressBlock: DownloadProgressBlock? = nil,
                  completionHandler: CompletionHandler? = nil) {
        kf.setImage(with: url,
                    for: .normal,
                    placeholder: placeholder,
                    options: options,
                    progressBlock: progressBlock,
                    completionHandler: completionHandler)
    }
    
    func setBackgroundImage(with url: URL?,
                            placeholder: UIImage? = nil,
                            options: KingfisherOptionsInfo = [.transition(.fade(0.2))],
                            progressBlock: DownloadProgressBlock? = nil,
                            completionHandler: CompletionHandler? = nil) {
        kf.setImage(with: url,
                    for: .normal,
                    placeholder: placeholder,
                    options: options,
                    progressBlock: progressBlock,
                    completionHandler: completionHandler)
    }
}
