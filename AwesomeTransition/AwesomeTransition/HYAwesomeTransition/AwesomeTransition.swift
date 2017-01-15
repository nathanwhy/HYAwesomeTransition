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
    var finalFrame: CGRect = CGRect.zero
    var containerBackgroundView: UIView?
    var isPresent: Bool = false
    private let scale = UIScreen.main.bounds.size.height
    private var transitionView: UIView?
    
    private var snapshotView: UIView?
    private var startFrame: CGRect = CGRect.zero
    
    func registerTransition(_ startRect: CGRect, finalRect: CGRect, transitionView: UIView) {
        startFrame = startRect;
        finalFrame = finalRect;
        snapshotView = transitionView.snapshotView()
        snapshotView?.layer.shadowOpacity = 0.5;
        snapshotView?.layer.shadowRadius = 3;
        snapshotView?.layer.shadowColor = UIColor.lightGray.cgColor
        snapshotView?.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.transitionView = transitionView
    }
    
    // MARK: UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            present(transitionContext)
        }else{
            dismiss(transitionContext)
        }
    }
    
    fileprivate func present(_ transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
              let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
              let snapshot = snapshotView
              else { return }
		
		let containerView = transitionContext.containerView
        
        if let containerBackground = containerBackgroundView {
            containerBackground.frame = containerView.bounds;
            containerBackground.alpha = 0.0;
            containerView.addSubview(containerBackground)
        }
		
        containerView.addSubview(toVC.view)
        
        let x = finalFrame.origin.x - startFrame.origin.x;
        let y = finalFrame.origin.y - startFrame.origin.y;
        
        snapshot.frame = startFrame
        containerView.addSubview(snapshot)
        
        var upViewTransfrom = CATransform3DIdentity
        upViewTransfrom.m34 = 1.0 / -1000.0
        upViewTransfrom = CATransform3DTranslate(upViewTransfrom, 0, 0, 100)
        
        let middleViewTranfrom = CATransform3DTranslate(upViewTransfrom, x, y, 0)
        let downViewTranfrom = CATransform3DTranslate(middleViewTranfrom, 0, 0, -100)
        let partDuration = duration / 3
        
        toVC.view.isHidden = true
        self.transitionView?.isHidden = true
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: UIViewKeyframeAnimationOptions(), animations: { 
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: { 
                snapshot.layer.transform = upViewTransfrom
                fromVC.view.alpha = 0.0
                if let containerBackground = self.containerBackgroundView {
                    containerBackground.alpha = 1.0
                }
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: { 
                snapshot.layer.transform = middleViewTranfrom
            })
            }) { (finished) in
                toVC.view.isHidden = false
                let rect = self.finalFrame.insetBy(dx: -self.scale, dy: -self.scale)
                let startPath = CGPath(ellipseIn: rect, transform: nil)
                let endPath = CGPath(ellipseIn: self.finalFrame, transform: nil)
                
                let maskLayer = CAShapeLayer()
                maskLayer.path = startPath;
                
                toVC.view.layer.mask = maskLayer
                
                let pingAnimation = CABasicAnimation(keyPath: "path")
                pingAnimation.fromValue = endPath
                pingAnimation.toValue = startPath
                pingAnimation.duration = partDuration
                pingAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                
                maskLayer.add(pingAnimation, forKey: "pingInvert")
				
                UIView.animate(withDuration: partDuration, animations: { 
                    snapshot.layer.transform = downViewTranfrom
                    }, completion: { (finished) in
                        fromVC.view.alpha = 1.0
                        self.containerBackgroundView?.alpha = 1.0
                        self.snapshotView?.removeFromSuperview()
                        maskLayer.removeFromSuperlayer()
                        transitionContext.completeTransition(true)
                })
                
        }
    }
    
    fileprivate func dismiss(_ transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let snapshot = snapshotView
            else { return }
		let containerView = transitionContext.containerView
        
        containerView.addSubview(toVC.view)
        if let containerBackground = containerBackgroundView {
            containerBackground.frame = containerView.bounds;
            containerView.addSubview(containerBackground)
        }
		
        containerView.addSubview(fromVC.view)
        
        let x = startFrame.origin.x - finalFrame.origin.x;
        let y = startFrame.origin.y - finalFrame.origin.y;
        
        snapshot.transform = CGAffineTransform.identity
        snapshot.frame = finalFrame
        containerView.addSubview(snapshot)
        
        toVC.view.isHidden = true
        
        var upViewTransfrom = CATransform3DIdentity
        upViewTransfrom.m34 = 1.0 / -1000.0
        upViewTransfrom = CATransform3DTranslate(upViewTransfrom, 0, 0, 100)
        
        let middleViewTranfrom = CATransform3DTranslate(upViewTransfrom, x, y, 0)
        let downViewTranfrom = CATransform3DTranslate(middleViewTranfrom, 0, 0, -100)
        let partDuration = duration / 3
        let rect = finalFrame.insetBy(dx: -self.scale, dy: -self.scale)
        
        let endPath = CGPath(ellipseIn: rect, transform: nil)
        let startPath = CGPath(ellipseIn: self.finalFrame, transform: nil)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = startPath;
        
        fromVC.view.layer.mask = maskLayer
        
        let pingAnimation = CABasicAnimation(keyPath: "path")
        pingAnimation.fromValue = endPath
        pingAnimation.toValue = startPath
        pingAnimation.duration = partDuration
        pingAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        maskLayer.add(pingAnimation, forKey: "pingInvert")
        
        UIView.animate(withDuration: partDuration, animations: {
            snapshot.layer.transform = upViewTransfrom
        }, completion: { (finished) in
            fromVC.view.removeFromSuperview()
            toVC.view.isHidden = false
            
            UIView.animateKeyframes(withDuration: partDuration * 2, delay: 0, options: UIViewKeyframeAnimationOptions(), animations: { 
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: { 
                    snapshot.layer.transform = middleViewTranfrom
                })
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: { 
                    snapshot.layer.transform = downViewTranfrom
                    self.containerBackgroundView?.alpha = 0.0
                })
                
                }, completion: { (finish) in
                    self.containerBackgroundView?.removeFromSuperview()
                    self.transitionView?.isHidden = false
                    maskLayer.removeFromSuperlayer()
                    snapshot.removeFromSuperview()
                    transitionContext.completeTransition(true)
            })
        }) 
    }
}

public extension UIView {
	public func snapshotImage() -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
		drawHierarchy(in: bounds, afterScreenUpdates: false)
		let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return snapshotImage
	}
	
	public func snapshotView() -> UIView? {
		if let snapshotImage = snapshotImage() {
			return UIImageView(image: snapshotImage)
		} else {
			return nil
		}
	}
}

