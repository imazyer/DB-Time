//
//  FlipPresentAnimationController.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/5.
//  Copyright © 2018 Mazy. All rights reserved.
//

import UIKit

class FlipPresentAnimationController: UIViewController {
    var originFrame: CGRect = .zero
}

extension FlipPresentAnimationController: UIViewControllerAnimatedTransitioning {
    
    /// 模态呈现的时间间隔
    ///
    /// - Parameter transitionContext: 转场上下文
    /// - Returns: 返回时间间隔
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
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
        
        // 初始frame
        let initialFrame = originFrame
        // 最终frame
        let finialFrame = transitionContext.finalFrame(for: toVC)
        // 目标控制器的截屏(初始化之后的)
        let snapshot = AnimationHelper.getCurrentGraphicsImage(view: toVC.view)
        // 设置目标控制器的初始大小
        snapshot.frame = initialFrame
        // 切圆角
        snapshot.layer.cornerRadius = 25
        snapshot.layer.masksToBounds = true
        // 添加到容器视图中
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        // 隐藏目标控制器视图
        toVC.view.isHidden = true
        // 设置动画属性
        AnimationHelper.perspectiveTransformForContainerView(containerView: containerView)
        // 默认让目标视图的截屏 Y轴 旋转180度
        snapshot.layer.transform = AnimationHelper.yRotation(angle: CGFloat(Double.pi/2))
        // 获取动画时间间隔
        let duration = transitionDuration(using: transitionContext)
        // 1 定义关键帧动画
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
            // 2 添加关键帧动画 01 - 让主控制器旋转180度
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.33, animations: {
                fromVC.view.layer.transform = AnimationHelper.yRotation(angle: -CGFloat(Double.pi/2))
            })
            // 3 添加关键帧动画 02 - 切换目标控制器的动画, 让目标控制器截屏旋转180度展示出来
            UIView.addKeyframe(withRelativeStartTime: 0.33, relativeDuration: 0.33, animations: {
                snapshot.layer.transform = AnimationHelper.yRotation(angle: 0)
            })
            // 4 添加关键帧动画 03 - 设置目标控制器截屏的大小为最终大小
            UIView.addKeyframe(withRelativeStartTime: 0.66, relativeDuration: 0.33, animations: {
                snapshot.frame = finialFrame
            })
        }, completion: { _ in
            // 显示目标控制器
            toVC.view.isHidden = false
            // 恢复根控制器的 transfrom 初始转态
            fromVC.view.layer.transform = AnimationHelper.yRotation(angle: 0)
            // 移除截屏
            snapshot.reloadInputViews()
            // 完成模态跳转动画
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
