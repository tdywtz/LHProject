//
//  CustomItemViewController.m
//  LHProject
//
//  Created by bangong on 16/4/12.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "LHCustomItemViewController.h"

@implementation LHCustomItemViewController
{
    UIButton *view1;
    UIView *view2;
    UIView *view3;
    UIView *view4;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    view1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 700, 20, 20)];
    [view1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    view1.backgroundColor = [UIColor redColor];
    [self.view addSubview:view1];
    
    view2 = [[UIView alloc] initWithFrame:CGRectMake(100, 700, 20, 20)];
    view2.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view2];
    
    view3 = [[UIView alloc] initWithFrame:CGRectMake(100, 700, 20, 20)];
    view3.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:view3];
    
    view4 = [[UIView alloc] initWithFrame:CGRectMake(100, 700, 20, 20)];
    view4.backgroundColor = [UIColor greenColor];
    [self.view addSubview:view4];
    
    [self showItems];
    
    self.view.backgroundColor = [UIColor whiteColor];
}


-(void)buttonClick:(UIButton *)btn{
   // [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    btn.layer.opacity = 1.0;
    POPSpringAnimation *layerScaleAnimation1 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    
    layerScaleAnimation1.springBounciness = 18;
    layerScaleAnimation1.toValue = [NSValue valueWithCGSize:CGSizeMake(1.3f, 1.3f)];
    [btn.layer pop_addAnimation:layerScaleAnimation1 forKey:@"labelScaleAnimation1"];
    
    POPSpringAnimation *layerPositionAnimation2 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    layerPositionAnimation2.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];;
    layerPositionAnimation2.springBounciness = 18;
    layerPositionAnimation2.beginTime = CACurrentMediaTime()+0.2;
    [btn.layer pop_addAnimation:layerPositionAnimation2 forKey:@"labelScaleAnimation2"];
    [self hiddenItems];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

-(void)showItems{

        [self initailzerAnimationWithToPostion:CGRectMake(1, 200, 20, 20) formPostion:CGRectMake(1, 700, 20, 20) atView:view1 beginTime:0.1];
        [self initailzerAnimationWithToPostion:CGRectMake(100, 400, 20, 20) formPostion:CGRectMake(100, 700, 20, 20) atView:view2 beginTime:0.2];
        [self initailzerAnimationWithToPostion:CGRectMake(300, 400, 20, 20) formPostion:CGRectMake(300, 700, 20, 20) atView:view3 beginTime:0.3];
        [self initailzerAnimationWithToPostion:CGRectMake(200, 400, 20, 20) formPostion:CGRectMake(200, 700, 20, 20) atView:view4 beginTime:0.4];
  
}

-(void)hiddenItems{
    [self initailzerAnimationWithToPostion:CGRectMake(1, 700, 20, 20) formPostion:CGRectMake(1, 400, 20, 20) atView:view1 beginTime:0.1];
    [self initailzerAnimationWithToPostion:CGRectMake(100, 700, 20, 20) formPostion:CGRectMake(100, 400, 20, 20) atView:view2 beginTime:0.2];
    [self initailzerAnimationWithToPostion:CGRectMake(300, 700, 20, 20) formPostion:CGRectMake(300, 400, 20, 20) atView:view3 beginTime:0.3];
    [self initailzerAnimationWithToPostion:CGRectMake(200, 700, 20, 20) formPostion:CGRectMake(200, 400, 20, 20) atView:view4 beginTime:0.4];
}


- (void)initailzerAnimationWithToPostion:(CGRect)toRect formPostion:(CGRect)fromRect atView:(UIView *)view beginTime:(CFTimeInterval)beginTime {
    
    POPSpringAnimation *springAnimation = [POPSpringAnimation animation];
    springAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    springAnimation.removedOnCompletion = YES;
    springAnimation.beginTime = beginTime + CACurrentMediaTime();
    CGFloat springBounciness = 10 - beginTime * 2;
    springAnimation.springBounciness = springBounciness;    // value between 0-20
    
    
    springAnimation.dynamicsFriction = 0.4;
    CGFloat springSpeed = 12 - beginTime * 2;
    springAnimation.springSpeed = springSpeed;     // value between 0-20
    springAnimation.toValue = [NSValue valueWithCGRect:toRect];
    springAnimation.fromValue = [NSValue valueWithCGRect:fromRect];
    // springAnimation.roundingFactor = 1;
    [view pop_removeAnimationForKey:@"POPSpringAnimationKey"];
    [view pop_addAnimation:springAnimation forKey:@"POPSpringAnimationKey"];
    
}

@end
