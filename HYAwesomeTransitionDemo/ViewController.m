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
@property (nonatomic, strong) HYAwesomeTransition *awesometransition;
@property (nonatomic, strong) NSMutableArray *imagesArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imagesArray = @[].mutableCopy;
    for (int i = 0; i < 30; i++) {
        [self.imagesArray addObject:@"doge2"];
    }
    [self.imagesArray replaceObjectAtIndex:10 withObject:@"doge"];
    
    self.awesometransition = [[HYAwesomeTransition alloc] init];
    self.awesometransition.type = HYTransitionTypeModal;
    self.awesometransition.duration = 1.5f;
    self.awesometransition.containerBackgroundView = ({
        UIView *bgView = (UIView *)[[[NSBundle mainBundle] loadNibNamed:@"ContainerBackgroundView" owner:nil options:nil] lastObject];
        bgView;
    });
}

#pragma mark - collectionView


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ReuseIdentifier = @"CustomMainCell";
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:self.imagesArray[indexPath.row]];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imagesArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    if (self.awesometransition.type == HYTransitionTypeModal) {
        
        ModalViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ModalViewController"];
        vc.imageName = self.imagesArray[indexPath.row];
        vc.transitioningDelegate = self;
        vc.delegate              = self;
        
        CGRect startFrame = [cell convertRect:cell.bounds toView:self.view];
        CGRect finalFrame = CGRectMake(40, 150, 100, 100);
        
        [self.awesometransition registerStartFrame:startFrame
                                        finalFrame:finalFrame transitionView:cell];
        
        [self presentViewController:vc animated:YES completion:^{
            vc.avatar.hidden = NO;
            vc.avatar.image = [UIImage imageNamed:self.imagesArray[indexPath.row]];
        }];
    } else {
        ModalViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ModalViewController"];
        vc.imageName = self.imagesArray[indexPath.row];
        vc.delegate              = self;
        
        CGRect startFrame = [cell convertRect:cell.bounds toView:self.view];
        CGRect finalFrame = CGRectMake(40, 150, 100, 100);
        
        [self.awesometransition registerStartFrame:startFrame
                                        finalFrame:finalFrame transitionView:cell];
        
        self.navigationController.delegate = self;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - ModelViewController delegate

- (void)modalViewControllerDidClickedDismissButton:(ModalViewController *)viewController {
    self.awesometransition.finalFrame = [viewController.avatar convertRect:viewController.avatar.bounds toView:viewController.view];
    viewController.avatar.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma makr - Action

- (IBAction)segmentedControlAction:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 1) {
        self.awesometransition.type = HYTransitionTypeNavigation;
    } else {
        self.awesometransition.type = HYTransitionTypeModal;
    }
}

#pragma mark - transition

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.awesometransition.present = YES;
    return self.awesometransition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.awesometransition.present = NO;
    return self.awesometransition;
}

// If you use UINavigationController, you have to implement UINavigationControllerDelegate
// instead of UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    self.awesometransition.type = HYTransitionTypeNavigation;
    if (operation == UINavigationControllerOperationPush) {
        self.awesometransition.present = YES;
    } else {
        self.awesometransition.present = NO;
    }
    return self.awesometransition;
}


@end
