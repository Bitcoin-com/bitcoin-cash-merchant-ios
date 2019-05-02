//
//  CircleAnimationController.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/26.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit
import BDCKit

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
        
        maskView.frame.origin.y += originFrame.height
        if #available(iOS 11.0, *) {
            maskView.frame.origin.y += fromVC.view.safeAreaInsets.top
        }
        maskView.frame.origin.x = 16
        maskView.frame.size.width = snapshot.frame.size.width - 32
        maskView.frame.size.height += 16
        maskView.layer.cornerRadius = 32
        
        snapshot.frame.origin.y = -(snapshot.frame.height/2 + 100)
        snapshot.frame.origin.x = -16
        
        let blurView = UIVisualEffectView(effect: nil)
        blurView.effect = UIBlurEffect(style: .dark)
        blurView.alpha = 0
        
        toVC.view.isHidden = true
        
        let containerView = transitionContext.containerView
        containerView.addSubview(blurView)
        containerView.addSubview(maskView)
        containerView.insertSubview(toVC.view, at: 0)
        blurView.fillSuperView()
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: {
            maskView.frame = finalFrame
            snapshot.frame = finalFrame
            maskView.layer.cornerRadius = 0
        }) { _ in
            blurView.removeFromSuperview()
            maskView.removeFromSuperview()
            toVC.view.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        UIView.animate(withDuration: 0.4, animations: {
            blurView.alpha = 1
        })
        
    }
}


class CircleDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let originFrame: CGRect
    let interactionController: CircleInteractionController?
    
    init(originFrame: CGRect, interactionController: CircleInteractionController?) {
        self.originFrame = originFrame
        self.interactionController = interactionController
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from)
            , let toVC = transitionContext.viewController(forKey: .to)
            , let snapshot = fromVC.view.snapshotView(afterScreenUpdates: true)
            , let snapshotTo = toVC.view.snapshotView(afterScreenUpdates: true)
            else {
                return
        }
        
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        let maskView = UIView(frame: finalFrame)
        maskView.clipsToBounds = true
        maskView.layer.cornerRadius = 0
        maskView.addSubview(snapshot)
        
        snapshot.frame = finalFrame
        
        let blurView = UIVisualEffectView(effect: nil)
        blurView.effect = UIBlurEffect(style: .dark)
        blurView.alpha = 1
        
        let containerView = transitionContext.containerView
        containerView.addSubview(snapshotTo)
        containerView.addSubview(blurView)
        containerView.addSubview(maskView)
        blurView.fillSuperView()
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: {
            maskView.frame = self.originFrame
            maskView.frame.origin.y = -6 + self.originFrame.origin.y + self.originFrame.height
            if #available(iOS 11.0, *) {
                 maskView.frame.origin.y += fromVC.view.safeAreaInsets.top
            }
            maskView.frame.origin.x = 16
            maskView.frame.size.width = snapshot.frame.size.width - 32
            maskView.frame.size.height += 16
            maskView.layer.cornerRadius = 32
            
            snapshot.frame.origin.y = -(snapshot.frame.height/2 + 100)
            snapshot.frame.origin.x = -16
            
            blurView.alpha = 0
        }) { _ in
            snapshotTo.removeFromSuperview()
            blurView.removeFromSuperview()
            maskView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
}
