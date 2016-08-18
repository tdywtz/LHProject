

//
//  LHPushAnimator.m
//  LHProject
//
//  Created by luhai on 16/4/23.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "LHPushAnimator.h"

@implementation LHPushAnimator

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 1.0f;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    toVC.view.userInteractionEnabled = YES;

    CGRect fnialFrameForVC = [transitionContext finalFrameForViewController:toVC];
    CGRect bounds = [UIScreen mainScreen].bounds;
    toVC.view.frame = CGRectOffset(fnialFrameForVC, bounds.size.width, 0);
    [[transitionContext containerView] addSubview:toVC.view];
    
    [UIView animateWithDuration:2.4 animations:^{
        fromVC.view.frame = fnialFrameForVC;
        toVC.view.frame = fnialFrameForVC;
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
        fromVC.view.alpha = 1;
    }];
}


@end
