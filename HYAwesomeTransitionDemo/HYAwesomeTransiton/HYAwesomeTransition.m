//
//  HYAwesomTransition.m
//  HYAwesomeTransitionDemo
//
//  Created by nathan on 15/7/30.
//  Copyright (c) 2015年 nathan. All rights reserved.
//

#import "HYAwesomeTransition.h"


@interface HYAwesomeTransition()

@property (nonatomic, strong)UIView *snapshotView;
@property (nonatomic, assign)CGRect startFrame;
@property (nonatomic, assign)CGRect finalFrame;
@property (nonatomic, copy) void (^completion)(BOOL finished);
@end

@implementation HYAwesomeTransition

- (void)registerStartFrame:(CGRect)startFrame
                finalFrame:(CGRect)finalFrame
            transitionView:(UIView *)transitionView {
    
    _startFrame = startFrame;
    _finalFrame = finalFrame;
    _snapshotView = [transitionView snapshotViewAfterScreenUpdates:NO];
    
    _snapshotView.layer.shadowOpacity = 0.5;
    _snapshotView.layer.shadowRadius = 3;
    _snapshotView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _snapshotView.layer.shadowOffset = CGSizeMake(5, 5);
}


- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    if (self.present) {
        
        [self presentWithTransiton:transitionContext];
    }else{
        
        [self dismissWithTranstion:transitionContext];
    }
}

- (void)presentWithTransiton:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    if (self.containerBackgroundView) {
        self.containerBackgroundView.frame = containerView.bounds;
        self.containerBackgroundView.alpha = 0.0;
        [containerView addSubview:self.containerBackgroundView];
    }
    
    [containerView addSubview:toVC.view];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    CGFloat x = _finalFrame.origin.x - _startFrame.origin.x;
    CGFloat y = _finalFrame.origin.y - _startFrame.origin.y;
    
    
    UIView *snapshotView = self.snapshotView;
    snapshotView.frame = _startFrame;
    [containerView addSubview:snapshotView];
    
    CATransform3D upViewTransfrom = CATransform3DIdentity;
    upViewTransfrom.m34 = 1.0 / -1000;
    upViewTransfrom = CATransform3DTranslate(upViewTransfrom, 0, 0, 100);
    
    CATransform3D middleViewTranfrom = CATransform3DTranslate(upViewTransfrom, x, y, 0);
    CATransform3D downViewTranfrom   = CATransform3DTranslate(middleViewTranfrom, 0, 0, -100);
    
    
    toVC.view.hidden = YES;
    
    NSTimeInterval partDuration = duration / 3;
    
    [UIView animateKeyframesWithDuration:partDuration * 3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
            snapshotView.layer.transform = upViewTransfrom;
            fromVC.view.alpha = 0.0;
            if (self.containerBackgroundView) {
                self.containerBackgroundView.alpha = 1.0;
            }
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
            snapshotView.layer.transform = middleViewTranfrom;
        }];
        
    } completion:^(BOOL finished) {
        
        toVC.view.hidden = NO;
        
        CGRect rect = CGRectInset(_finalFrame, -500, -500);
        
        CGPathRef startPath = CGPathCreateWithEllipseInRect(rect, NULL);
        CGPathRef endPath   = CGPathCreateWithEllipseInRect(_finalFrame, NULL);
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.path = startPath;
        
        toVC.view.layer.mask = maskLayer;
        
        
        CABasicAnimation *pingAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        pingAnimation.fromValue = (__bridge id)(endPath);
        pingAnimation.toValue   = (__bridge id)(startPath);
        pingAnimation.duration  = partDuration;
        pingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        [maskLayer addAnimation:pingAnimation forKey:@"pingInvert"];
        
        CGPathRelease(startPath);
        CGPathRelease(endPath);
        
        
        [UIView animateWithDuration:partDuration animations:^{
            
            snapshotView.layer.transform = downViewTranfrom;
        } completion:^(BOOL finished) {
            fromVC.view.alpha = 1.0;
            if (self.containerBackgroundView) {
                [self.containerBackgroundView removeFromSuperview];
            }
            [maskLayer removeFromSuperlayer];
            [snapshotView removeFromSuperview];
            [transitionContext completeTransition:YES];
            
        }];
    }];
    
}

- (void)dismissWithTranstion:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    
    [containerView addSubview:toVC.view];
    if (self.containerBackgroundView) {
        self.containerBackgroundView.frame = containerView.bounds;
        [containerView addSubview:self.containerBackgroundView];
    }
    [containerView addSubview:fromVC.view];
    
    CGFloat x = _startFrame.origin.x - _finalFrame.origin.x;
    CGFloat y = _startFrame.origin.y - _finalFrame.origin.y;
    
    
    UIView *snapshotView = self.snapshotView;
    
    snapshotView.transform = CGAffineTransformIdentity;
    snapshotView.frame = _finalFrame;
    [containerView addSubview:snapshotView];
    
    toVC.view.hidden = YES;
    
    CATransform3D upViewTransfrom = CATransform3DIdentity;
    upViewTransfrom.m34 = 1.0 / -1000;
    upViewTransfrom = CATransform3DTranslate(upViewTransfrom, 0, 0, 100);
    
    CATransform3D middleViewTranfrom = CATransform3DTranslate(upViewTransfrom, x, y, 0);
    CATransform3D downViewTranfrom   = CATransform3DTranslate(middleViewTranfrom, 0, 0, -100);
    
    NSTimeInterval partDuration = [self transitionDuration:transitionContext] / 3;
    
    CGRect rect = CGRectInset(_finalFrame, -500, -500);
    
    CGPathRef endPath   = CGPathCreateWithEllipseInRect(rect, NULL);
    CGPathRef startPath = CGPathCreateWithEllipseInRect(_finalFrame, NULL);
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = startPath;
    fromVC.view.layer.mask = maskLayer;
    
    CABasicAnimation *pingAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pingAnimation.fromValue = (__bridge id)(endPath);
    pingAnimation.toValue   = (__bridge id)(startPath);
    pingAnimation.duration  = partDuration;
    pingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [maskLayer addAnimation:pingAnimation forKey:@"pingInvert"];
    
    CGPathRelease(startPath);
    CGPathRelease(endPath);
    
    
    [UIView animateWithDuration:partDuration animations:^{
        
        snapshotView.layer.transform = upViewTransfrom;
        
    } completion:^(BOOL finished) {
        [fromVC.view removeFromSuperview];
        toVC.view.hidden = NO;
        
        [UIView animateKeyframesWithDuration:partDuration * 2 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
                snapshotView.layer.transform = middleViewTranfrom;
            }];
            
            [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
                snapshotView.layer.transform = downViewTranfrom;
                if (self.containerBackgroundView) {
                    self.containerBackgroundView.alpha = 0.0;
                }
            }];
            
        } completion:^(BOOL finished) {
            
            if (self.containerBackgroundView) {
                [self.containerBackgroundView removeFromSuperview];
            }
            snapshotView.hidden = NO;
            [snapshotView removeFromSuperview];
            [toVC.view removeFromSuperview];
            [fromVC.view removeFromSuperview];
            [transitionContext completeTransition:YES];
            
        }];
    }];
}

@end
