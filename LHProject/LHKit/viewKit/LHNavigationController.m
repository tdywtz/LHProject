//
//  LHNavigationController.m
//  LHProject
//
//  Created by bangong on 16/3/31.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "LHNavigationController.h"

@interface LHNavigationController ()<UIGestureRecognizerDelegate>
{
    CGPoint startTouch;
    
      UIImageView *lastScreenShotView;
     UIView *blackMask;

}
@property (nonatomic,retain) UIView *backgroundView;
@property (nonatomic,retain) NSMutableArray *screenShotsList;

@end

@implementation LHNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
                _screenShotsList = [[NSMutableArray alloc] initWithCapacity:2];
        
        
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.interactivePopGestureRecognizer.delegate = self;
    //[self setUp];
    
}

-(void)setUp{
    //屏蔽掉iOS7以后自带的滑动返回手势 否则有BUG
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }

    UIImageView *shadowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"leftside_shadow_bg"]];
    shadowImageView.frame = CGRectMake(-10, 0, 10, self.view.frame.size.height);
    [self.view addSubview:shadowImageView];

    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                action:@selector(paningGestureReceive:)];
    [recognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:recognizer];
}

//// override the push method
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
   // [self.screenShotsList addObject:[self capture]];
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.5f;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = @"rippleEffect";
//    transition.subtype = kCATransitionMoveIn;
//    transition.delegate = self;
//    [self.view.layer addAnimation:transition forKey:nil];
    [super pushViewController:viewController animated:animated];
//    animation.type = kCATransitionFade;
//    
//    animation.type = kCATransitionPush;
//    
//    animation.type = kCATransitionReveal;
//    
//    animation.type = kCATransitionMoveIn;
//    
//    animation.type = @"cube";
//    
//    animation.type = @"suckEffect";
//    
//    // 页面旋转
//    animation.type = @"oglFlip";
//    
//    //水波纹
//    animation.type = @"rippleEffect";
//    
//    animation.type = @"pageCurl";
//    
//    animation.type = @"pageUnCurl";
//    
//    animation.type = @"cameraIrisHollowOpen";
//    
//    animation.type = @"cameraIrisHollowClose";
}

- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated{
//    CATransition *transition = [CATransition animation];
//    transition.duration = 1.0f;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = @"MoveIn";
//    transition.subtype = kCATransitionFromLeft;
//    transition.delegate = self;
//    [self.view.layer addAnimation:transition forKey:nil];
//    
    return [super popViewControllerAnimated:animated];
}
//
//// override the pop method
//- (UIViewController *)popViewControllerAnimated:(BOOL)animated
//{
//    [self.screenShotsList removeLastObject];
//
//    return [super popViewControllerAnimated:animated];
//}
//
//#pragma mark - Utility Methods -
//
//// get the current view screen shot
//- (UIImage *)capture
//{
//    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
//    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//
//    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
//
//    UIGraphicsEndImageContext();
//
//    return img;
//}
//
//
//- (void)moveViewWithX:(float)x
//{
//
//  //  NSLog(@"Move to:%f",x);
//    x = x>
//    WIDTH?WIDTH:x;
//    x = x<0?0:x;
//
//    CGRect frame = self.view.frame;
//    frame.origin.x = x;
//    self.view.frame = frame;
//
//    float scale = (x/6400)+0.95;
//    float alpha = 0.4 - (x/800);
//
//    lastScreenShotView.transform = CGAffineTransformMakeScale(scale, scale);
//    blackMask.alpha = alpha;
//
//}
//
//#pragma mark - Gesture Recognizer -
//
//- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
//{
//    // If the viewControllers has only one vc or disable the interaction, then return.
//    if (self.viewControllers.count <= 1) return;
//
//    // we get the touch position by the window's coordinate
//    CGPoint touchPoint = [recoginzer locationInView:[UIApplication sharedApplication].keyWindow];
//    // begin paning, show the backgroundView(last screenshot),if not exist, create it.
//    if (recoginzer.state == UIGestureRecognizerStateBegan) {
//
//       
//        startTouch = touchPoint;
//
//        if (!self.backgroundView)
//        {
//            CGRect frame = self.view.frame;
//
//            self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
//            [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
//
//            blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
//            blackMask.backgroundColor = [UIColor blackColor];
//            [self.backgroundView addSubview:blackMask];
//        }
//
//        self.backgroundView.hidden = NO;
//
//        if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
//
//        UIImage *lastScreenShot = [self.screenShotsList lastObject];
//        lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
//        [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];
//
//        //End paning, always check that if it should move right or move left automatically
//    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
//
//        if (touchPoint.x - startTouch.x > 50)
//        {
//            [UIView animateWithDuration:0.3 animations:^{
//                [self moveViewWithX:375];
//            } completion:^(BOOL finished) {
//
//                [self popViewControllerAnimated:NO];
//                CGRect frame = self.view.frame;
//                frame.origin.x = 0;
//                self.view.frame = frame;
//
//            
//            }];
//        }
//        else
//        {
//            [UIView animateWithDuration:0.3 animations:^{
//                [self moveViewWithX:0];
//            } completion:^(BOOL finished) {
//       
//                self.backgroundView.hidden = YES;
//            }];
//
//        }
//        return;
//
//        // cancal panning, alway move to left side automatically
//    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
//
//        [UIView animateWithDuration:0.3 animations:^{
//            [self moveViewWithX:0];
//        } completion:^(BOOL finished) {
//          
//            self.backgroundView.hidden = YES;
//        }];
//
//        return;
//    }
//
//        [self moveViewWithX:touchPoint.x - startTouch.x];
//    
//}
//

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    [super pushViewController:viewController animated:animated];
//}
//
//- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated{
//    return [super popViewControllerAnimated:animated];
//}
//

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    if (self.childViewControllers.count == 1) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    return YES;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
