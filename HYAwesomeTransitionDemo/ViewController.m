//
//  ViewController.m
//  HYAwesomeTransitionDemo
//
//  Created by nathan on 15/7/30.
//  Copyright (c) 2015年 nathan. All rights reserved.
//

#import "ViewController.h"
#import "HYAwesomeTransition.h"
#import "ModalViewController.h"
#import "CustomCell.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIViewControllerTransitioningDelegate,ModalViewControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong)HYAwesomeTransition *awesometransition;
@property (nonatomic, weak) UICollectionViewCell *transitionCell;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.awesometransition = [[HYAwesomeTransition alloc] init];
    self.awesometransition.duration = 1.5f;
    self.awesometransition.containerBackgroundView = ({
        UIView *bgView = (UIView *)[[[NSBundle mainBundle] loadNibNamed:@"ContainerBackgroundView" owner:nil options:nil] lastObject];
        bgView;
    });
}

#pragma mark - collectionView
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ReuseIdentifier = @"CustomMainCell";
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    
    NSString *imageName = indexPath.row == 10? @"doge": @"doge2";
    cell.imageView.image = [UIImage imageNamed:imageName];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 30;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    ModalViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ModalViewController"];
    vc.imageName = indexPath.row == 10? @"doge": @"doge2";
    vc.transitioningDelegate = self;
    vc.delegate              = self;
    
    CGRect startFrame = [cell convertRect:cell.bounds toView:self.view];
    CGRect finalFrame = CGRectMake(40, 150, 100, 100);
    
    [self.awesometransition registerStartFrame:startFrame
                                    finalFrame:finalFrame transitionView:cell];
    
    cell.hidden = YES;
    self.transitionCell = cell;
    
    __weak ModalViewController *weakVC = vc;
    [self presentViewController:vc animated:YES completion:^{
        weakVC.avatar.hidden = NO;
    }];
}

#pragma mark - ModelViewController delegate

- (void)modalViewControllerDidClickedDismissButton:(ModalViewController *)viewController{
    self.awesometransition.finalFrame = [viewController.avatar convertRect:viewController.avatar.bounds toView:viewController.view];
    viewController.avatar.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:^{
        self.transitionCell.hidden = NO;
    }];
}

#pragma mark - transition

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.awesometransition.present = YES;
    return self.awesometransition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.awesometransition.present = NO;
    return self.awesometransition;
}

// If you use UINavigationController, you have to implement UINavigationControllerDelegate
// instead of UIViewControllerTransitioningDelegate
//
/*
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    if (operation == UINavigationControllerOperationPush) {
        self.awesometransition.present = YES;
    }else{
        self.awesometransition.present = NO;
        self.transitionCell.hidden = NO;
    }
    return self.awesometransition;
}
*/

@end
