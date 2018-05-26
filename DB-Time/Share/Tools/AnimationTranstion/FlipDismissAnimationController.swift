//
//  FlipDismissAnimationController.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/5.
//  Copyright © 2018 Mazy. All rights reserved.
//

import UIKit

class FlipDismissAnimationController: UIViewController {
    var destinationFrame: CGRect = .zero
}

extension FlipDismissAnimationController: UIViewControllerAnimatedTransitioning {
    /// 模态呈现的时间间隔
    ///
    /// - Parameter transitionContext: 转场上下文
    /// - Returns: 返回时间间隔
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    
    /// 控制动画
    ///
    /// - Parameter transitionContext: 转场上下文
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 获取容器视图
        let containerView = transitionContext.containerView
        // 获取当前控制器/目标控制器
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else { return }
        
        // 最终frame
        let finialFrame = destinationFrame
        // 根控制器的截屏(初始化之后的)
        let snapshot = AnimationHelper.getCurrentGraphicsImage(view: fromVC.view)
        // 切圆角
        snapshot.layer.cornerRadius = 25
        snapshot.layer.masksToBounds = true
        // 添加到容器视图中
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        // 隐藏根控制器视图
        fromVC.view.isHidden = true
        // 设置动画属性
        AnimationHelper.perspectiveTransformForContainerView(containerView: containerView)
        // 默认让目标视图的截屏 Y轴 旋转180度
        toVC.view.layer.transform = AnimationHelper.yRotation(angle: -CGFloat(Double.pi/2))
        // 获取动画时间间隔
        let duration = transitionDuration(using: transitionContext)
        // 1 定义关键帧动画
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
            // 2 添加关键帧动画 01 - 让主控制器旋转180度
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.33, animations: {
                snapshot.frame = finialFrame
            })
            // 3 添加关键帧动画 02 - 切换目标控制器的动画, 让目标控制器截屏旋转180度展示出来
            UIView.addKeyframe(withRelativeStartTime: 0.33, relativeDuration: 0.33, animations: {
                snapshot.layer.transform = AnimationHelper.yRotation(angle: CGFloat(Double.pi/2))
            })
            // 4 添加关键帧动画 03 - 设置目标控制器截屏的大小为最终大小
            UIView.addKeyframe(withRelativeStartTime: 0.66, relativeDuration: 0.33, animations: {
                toVC.view.layer.transform = AnimationHelper.yRotation(angle: 0)
            })
        }, completion: { _ in
            // 显示目标控制器
            fromVC.view.isHidden = false
            // 移除截屏
            snapshot.reloadInputViews()
            // 完成模态跳转动画
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
