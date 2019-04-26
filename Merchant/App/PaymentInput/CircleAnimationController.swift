//
//  CircleAnimationController.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/26.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit

class CirclePresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let originFrame: CGRect
    
    init(originFrame: CGRect) {
        self.originFrame = originFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from)
            , let toVC = transitionContext.viewController(forKey: .to)
            , let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)
            else {
                return
        }
        
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        let maskView = UIView(frame: originFrame)
        maskView.clipsToBounds = true
        maskView.addSubview(snapshot)
        
        print(fromVC.view.safeAreaInsets.top)
        
        maskView.frame.origin.y += fromVC.view.safeAreaInsets.top + originFrame.height
        maskView.frame.origin.x = 16
        maskView.frame.size.width = snapshot.frame.size.width - 32
        maskView.layer.cornerRadius = 32
        
        snapshot.frame.origin.y = -(snapshot.frame.height/2 + 106)
        snapshot.frame.origin.x = -16
        
        let blurView = UIVisualEffectView(effect: nil)
        blurView.effect = UIBlurEffect(style: .dark)
        blurView.alpha = 0
        
        toVC.view.isHidden = true
        
        let containerView = transitionContext.containerView
        containerView.addSubview(blurView)
        containerView.addSubview(maskView)
        containerView.addSubview(toVC.view)
        blurView.fillSuperView()
        
        UIView.animate(withDuration: 0.5, animations: {
            maskView.frame = finalFrame
            snapshot.frame = finalFrame
            maskView.layer.cornerRadius = 0
        }) { _ in
            blurView.removeFromSuperview()
            toVC.view.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            blurView.alpha = 1
        })
        
    }
}


class CircleDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let originFrame: CGRect
    
    init(originFrame: CGRect) {
        self.originFrame = originFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from)
            , let toVC = transitionContext.viewController(forKey: .to)
            , let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false)
            , let snapshotTo = toVC.view.snapshotView(afterScreenUpdates: false)
            else {
                return
        }
        
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        let maskView = UIView(frame: finalFrame)
        maskView.clipsToBounds = true
        maskView.layer.cornerRadius = 0
        maskView.addSubview(snapshot)
        maskView.layer.cornerRadius = 32
        
        snapshot.frame = finalFrame
        
        let blurView = UIVisualEffectView(effect: nil)
        blurView.effect = UIBlurEffect(style: .dark)
        blurView.alpha = 1
        
        fromVC.view.isHidden = true
        
        let containerView = transitionContext.containerView
        containerView.addSubview(snapshotTo)
        containerView.addSubview(blurView)
        containerView.addSubview(maskView)
        blurView.fillSuperView()
        
        UIView.animate(withDuration: 0.5, animations: {
            maskView.frame = self.originFrame
            maskView.frame.origin.y = self.originFrame.origin.y + fromVC.view.safeAreaInsets.top + self.originFrame.height
            maskView.frame.origin.x = 16
            maskView.frame.size.width = snapshot.frame.size.width - 32
            maskView.layer.cornerRadius = 32
            
            snapshot.frame.origin.y = -(snapshot.frame.height/2 + 108)
            snapshot.frame.origin.x = -16
            
            blurView.alpha = 0
        }) { _ in
            snapshotTo.removeFromSuperview()
            blurView.removeFromSuperview()
            fromVC.view.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
}
