//
//  AwesomeTransition.swift
//  AwesomeTransition
//
//  Created by why on 16/4/18.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit


class AwesomeTransition:NSObject, UIViewControllerAnimatedTransitioning {
    
    var duration = 1.5
    var finalFrame: CGRect = CGRectZero
    var containerBackgroundView: UIView?
    var isPresent: Bool = false
    let scale = UIScreen.mainScreen().bounds.size.height
    
    private var snapshotView: UIView?
    private var startFrame: CGRect = CGRectZero
    
    func registerTransition(startRect: CGRect, finalRect: CGRect, transitionView: UIView) {
        startFrame = startRect;
        finalFrame = finalRect;
        snapshotView = transitionView.snapshotViewAfterScreenUpdates(false)
        snapshotView?.layer.shadowOpacity = 0.5;
        snapshotView?.layer.shadowRadius = 3;
        snapshotView?.layer.shadowColor = UIColor.lightGrayColor().CGColor
        snapshotView?.layer.shadowOffset = CGSizeMake(5, 5)
    }
    
    // MARK: UIViewControllerAnimatedTransitioning
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            present(transitionContext)
        }else{
            dismiss(transitionContext)
        }
    }
    
    private func present(transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let containerView = transitionContext.containerView()!
        
        if let containerBackground = containerBackgroundView {
            containerBackground.frame = containerView.bounds;
            containerBackground.alpha = 0.0;
            containerView.addSubview(containerBackground)
        }
        
        containerView.addSubview(toVC.view)
        
        let x = finalFrame.origin.x - startFrame.origin.x;
        let y = finalFrame.origin.y - startFrame.origin.y;
        
        guard snapshotView != nil else {
            return
        }
        
        let snapshot = snapshotView!
        snapshot.frame = startFrame
        containerView.addSubview(snapshot)
        
        var upViewTransfrom = CATransform3DIdentity
        upViewTransfrom.m34 = 1.0 / -1000.0
        upViewTransfrom = CATransform3DTranslate(upViewTransfrom, 0, 0, 100)
        
        let middleViewTranfrom = CATransform3DTranslate(upViewTransfrom, x, y, 0)
        let downViewTranfrom = CATransform3DTranslate(middleViewTranfrom, 0, 0, -100)
        let partDuration = duration / 3
        
        toVC.view.hidden = true
        
        UIView.animateKeyframesWithDuration(duration, delay: 0, options: .CalculationModeLinear, animations: { 
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.5, animations: { 
                snapshot.layer.transform = upViewTransfrom
                fromVC.view.alpha = 0.0
                if let containerBackground = self.containerBackgroundView {
                    containerBackground.alpha = 1.0
                }
            })
            UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5, animations: { 
                snapshot.layer.transform = middleViewTranfrom
            })
            }) { (finished) in
                toVC.view.hidden = false
                let rect = CGRectInset(self.finalFrame, -self.scale, -self.scale)
                let startPath = CGPathCreateWithEllipseInRect(rect, nil)
                let endPath = CGPathCreateWithEllipseInRect(self.finalFrame, nil)
                
                let maskLayer = CAShapeLayer()
                maskLayer.path = startPath;
                
                toVC.view.layer.mask = maskLayer
                
                let pingAnimation = CABasicAnimation(keyPath: "path")
                pingAnimation.fromValue = endPath
                pingAnimation.toValue = startPath
                pingAnimation.duration = partDuration
                pingAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                
                maskLayer.addAnimation(pingAnimation, forKey: "pingInvert")
                
                // release path
                
                UIView.animateWithDuration(partDuration, animations: { 
                    snapshot.layer.transform = downViewTranfrom
                    }, completion: { (finished) in
                        fromVC.view.alpha = 1.0
                        if let containerBackground = self.containerBackgroundView {
                            containerBackground.alpha = 1.0
                        }
                        self.snapshotView?.removeFromSuperview()
                        maskLayer.removeFromSuperlayer()
                        transitionContext.completeTransition(true)
                })
                
        }
    }
    
    private func dismiss(transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let containerView = transitionContext.containerView()!
        
        containerView.addSubview(toVC.view)
        if let containerBackground = containerBackgroundView {
            containerBackground.frame = containerView.bounds;
            containerView.addSubview(containerBackground)
        }
        containerView.addSubview(fromVC.view)
        
        let x = startFrame.origin.x - finalFrame.origin.x;
        let y = startFrame.origin.y - finalFrame.origin.y;
        
        guard snapshotView != nil else {
            return
        }
        
        let snapshot = snapshotView!
        snapshot.transform = CGAffineTransformIdentity
        snapshot.frame = finalFrame
        containerView.addSubview(snapshot)
        
        toVC.view.hidden = true
        
        var upViewTransfrom = CATransform3DIdentity
        upViewTransfrom.m34 = 1.0 / -1000.0
        upViewTransfrom = CATransform3DTranslate(upViewTransfrom, 0, 0, 100)
        
        let middleViewTranfrom = CATransform3DTranslate(upViewTransfrom, x, y, 0)
        let downViewTranfrom = CATransform3DTranslate(middleViewTranfrom, 0, 0, -100)
        let partDuration = duration / 3
        let rect = CGRectInset(finalFrame, -self.scale, -self.scale)
        
        let endPath = CGPathCreateWithEllipseInRect(rect, nil)
        let startPath = CGPathCreateWithEllipseInRect(self.finalFrame, nil)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = startPath;
        
        fromVC.view.layer.mask = maskLayer
        
        let pingAnimation = CABasicAnimation(keyPath: "path")
        pingAnimation.fromValue = endPath
        pingAnimation.toValue = startPath
        pingAnimation.duration = partDuration
        pingAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        maskLayer.addAnimation(pingAnimation, forKey: "pingInvert")
        
        
        UIView.animateWithDuration(partDuration, animations: {
            snapshot.layer.transform = upViewTransfrom
        }) { (finished) in
            fromVC.view.removeFromSuperview()
            toVC.view.hidden = false
            
            UIView.animateKeyframesWithDuration(partDuration * 2, delay: 0, options: .CalculationModeLinear, animations: { 
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.5, animations: { 
                    snapshot.layer.transform = middleViewTranfrom
                })
                UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5, animations: { 
                    snapshot.layer.transform = downViewTranfrom
                    if let containerBackground = self.containerBackgroundView {
                        containerBackground.alpha = 0.0
                    }
                })
                
                }, completion: { (finish) in
                    if let containerBackground = self.containerBackgroundView {
                        containerBackground.removeFromSuperview()
                    }
                    maskLayer.removeFromSuperlayer()
                    snapshot.removeFromSuperview()
                    transitionContext.completeTransition(true)
            })
        }
    }
}

