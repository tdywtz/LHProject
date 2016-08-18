//
//  LHViewController.m
//  LHProject
//
//  Created by bangong on 16/3/31.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "LHViewController.h"
#import "LHPushAnimator.h"
#import "LHPopAnimator.h"
#import "PresentingAnimator.h"

@interface LHViewController ()<UINavigationControllerDelegate>

@end

@implementation LHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    self.view.backgroundColor = colorViewBackColor;
    if (self.navigationController.viewControllers.count > 1) {
        [self createLeftItem];
    }
}

-(void)createLeftItem{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"<--" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:22];
    [button sizeToFit];
    
    [button addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

-(void)leftItemClick{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - UINavigationControllerDelegate
//- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
//                                            animationControllerForOperation:(UINavigationControllerOperation)operation
//                                                         fromViewController:(UIViewController *)fromVC
//                                                           toViewController:(UIViewController *)toVC
//{
//    
//    if (operation == UINavigationControllerOperationPush) {
//        return [LHPushAnimator new];
//    }else if (operation == UINavigationControllerOperationPop){
//        return [LHPopAnimator new];
//    }
//    return nil;
//}

//- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
//                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController{
//    if ([animationController isKindOfClass:[POPAnimation class]]) {
//        return  [LHPopAnimator new];
//    }
//    return nil;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
