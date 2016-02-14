//
//  ModalViewController.h
//  HYAwesomeTransitionDemo
//
//  Created by nathan on 15/7/30.
//  Copyright (c) 2015年 nathan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModalViewController;
@protocol ModalViewControllerDelegate <NSObject>
-(void) modalViewControllerDidClickedDismissButton:(ModalViewController *)viewController;
@end

@interface ModalViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (nonatomic, weak) id<ModalViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *imageName;
@end
