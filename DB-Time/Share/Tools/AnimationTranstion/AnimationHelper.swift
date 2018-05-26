//
//  AnimationHelper.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/5.
//  Copyright © 2018 Mazy. All rights reserved.
//

import UIKit

class AnimationHelper {
    
    /// 设置角度进行 Y轴旋转
    ///
    /// - Parameter angle: 旋转角度
    /// - Returns: CATransform3D
    class func yRotation(angle: CGFloat) -> CATransform3D {
        return CATransform3DMakeRotation(angle, 0, 1, 0)
    }
    
    /// 设置子视图的动画属性
    ///
    /// - Parameter containerView: 容器视图
    class func perspectiveTransformForContainerView(containerView: UIView) {
        var transform = CATransform3DIdentity
        transform.m34 = -0.002
        containerView.layer.sublayerTransform = transform
    }
    
    /// 通过给定的视图 获取当前视图的截屏图像
    ///
    /// - Parameter view: 需要截屏的视图
    /// - Returns: UIImageView
    class func getCurrentGraphicsImage(view: UIView) -> UIImageView {
        // 宽/高
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        // 开启图像上下文
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        // 获取当前上下文
        if let content = UIGraphicsGetCurrentContext() {
            // 将上下文渲染到当前视图上
            view.layer.render(in: content)
        }
        // 获取图像上下文的当前图像
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭图像上下文
        UIGraphicsEndImageContext()
        // 返回图像的 ImageView
        return UIImageView(image: image)
    }
}
