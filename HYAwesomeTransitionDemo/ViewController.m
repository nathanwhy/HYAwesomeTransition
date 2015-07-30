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

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic)HYAwesomeTransition *awesometransition;

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
    
    //It is not good practice
    NSString *imageName = indexPath.row == 1? @"doge": @"doge2";
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:99];
    imageView.image = [UIImage imageNamed:imageName];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 12;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    ModalViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ModalViewController"];
    [vc loadView];
    vc.transitioningDelegate = self;
    
    CGRect startFrame = [cell convertRect:cell.bounds toView:self.view];
    CGRect finalFrame = vc.avatar.frame;
    
    [self.awesometransition registerStartFrame:startFrame finalFrame:finalFrame transitionView:cell];
    
    [self presentViewController:vc animated:YES completion:nil];
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

@end
