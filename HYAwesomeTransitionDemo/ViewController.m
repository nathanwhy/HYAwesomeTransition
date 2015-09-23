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

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIViewControllerTransitioningDelegate,ModalViewControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong)HYAwesomeTransition *awesometransition;
@property (nonatomic, weak) UICollectionViewCell *transitionCell;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.awesometransition = [[HYAwesomeTransition alloc] init];
    self.awesometransition.duration = 2.0f;
    self.awesometransition.containerBackgroundView = ({
        UIView *bgView = (UIView *)[[[NSBundle mainBundle] loadNibNamed:@"ContainerBackgroundView" owner:nil options:nil] lastObject];
        bgView;
    });
}

#pragma mark - collectionView
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ReuseIdentifier = @"CustomMainCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    
    //Just for demo. It was not good practice
    NSString *imageName = indexPath.row == 10? @"doge": @"doge2";
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:99];
    imageView.image = [UIImage imageNamed:imageName];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 30;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    ModalViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ModalViewController"];
    [vc loadView];
    vc.transitioningDelegate = self;
    vc.delegate              = self;
    vc.avatar.hidden         = YES;
    
    CGRect startFrame = [cell convertRect:cell.bounds toView:self.view];
    CGRect finalFrame = vc.avatar.frame;
    
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
