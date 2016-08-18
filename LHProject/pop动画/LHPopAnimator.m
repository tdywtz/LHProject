

//
//  LHPopAnimator.m
//  LHProject
//
//  Created by luhai on 16/4/23.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "LHPopAnimator.h"

@implementation LHPopAnimator
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 2.0f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    toVC.view.userInteractionEnabled = YES;
    
    CGRect fnialFrameForVC = [transitionContext finalFrameForViewController:toVC];
    CGRect bounds = [UIScreen mainScreen].bounds;
    toVC.view.frame = bounds;
    [[transitionContext containerView] addSubview:toVC.view];
    
    bounds.origin.x = WIDTH;
    [UIView animateWithDuration:2.4 animations:^{
        //fromVC.view.frame = bounds;
        toVC.view.frame =bounds;

    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
        fromVC.view.alpha = 1;
    }];
}

@end
