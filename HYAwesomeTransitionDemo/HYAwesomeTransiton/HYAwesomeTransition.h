//
//  HYAwesomTransition.h
//  HYAwesomeTransitionDemo
//
//  Created by nathan on 15/7/30.
//  Copyright (c) 2015年 nathan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HYAwesomeTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign)CGFloat duration;
@property (nonatomic, strong)UIView *containerBackgroundView;
@property (nonatomic, getter=isPresent)BOOL present;

- (void)registerStartFrame:(CGRect)startFrame
                finalFrame:(CGRect)finalFrame
            transitionView:(UIView *)transitionView;



@end
