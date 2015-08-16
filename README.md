# HYAwesomeTransition

Custom transition between viewcontrollers.

The idea comes from gewara(格瓦拉).

![screenshot](screenshot/screenshot.gif)

## Requirements

iOS 7.0 +



## Example

``` 
self.awesometransition = [[HYAwesomeTransition alloc] init];
self.awesometransition.duration = 2.0f;
self.awesometransition.containerBackgroundView = customView;
[self.awesometransition registerStartFrame:startFrame
                                finalFrame:finalFrame
                            transitionView:cell];

cell.hidden = YES;

[self presentViewController:vc animated:YES completion:^{
        vc.avatar.hidden = NO;
    }];
```

Implement `UIViewControllerTransitioningDelegate` and this delegate method:

``` 
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
```

you can also use `UINavigationControllerDelegate`, but interactive gesture is not suppored.

## License

HYAwesomeTransition is available under the MIT license. See the LICENSE file for more info.