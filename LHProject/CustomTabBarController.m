//
//  CustomTabBarController.m
//  12365auto
//
//  Created by bangong on 15/8/20.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "CustomTabBarController.h"
#import "ViewController0.h"
#import "LHFriendsViewController.h"
#import "ViewController2.h"
#import "CardViewController.h"

@interface CustomTabBarController ()<UITabBarControllerDelegate,UIScrollViewDelegate>
{
    UIPageControl *_page;
}
@end

@implementation CustomTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];

    ViewController0   *news        = [[ViewController0 alloc] init];
    LHFriendsViewController *car   = [[LHFriendsViewController alloc] init];
    ViewController2   *complain    = [[ViewController2 alloc] init];
    CardViewController *userCenter = [[CardViewController alloc] init];
    
    LHNavigationController *nNews       = [[LHNavigationController alloc] initWithRootViewController:news];
    LHNavigationController *nCar        = [[LHNavigationController alloc] initWithRootViewController:car];
    LHNavigationController *nComplain   = [[LHNavigationController alloc] initWithRootViewController:complain];
    LHNavigationController *nUserCenter = [[LHNavigationController alloc] initWithRootViewController:userCenter];
    
    news.title       = @"新闻";
    car.title        = @"布拉格依旧";
    complain.title   = @"空间";
    userCenter.title = @"个人中心";

    self.viewControllers = @[nNews,nCar,nComplain,nUserCenter];
   

    [self createCustomTabBar];
}


//自定义tabbar
-(void)createCustomTabBar{

    NSArray *  _nameArray = @[@"tabBar1",@"tabBar2",@"tabBar3",@"tabBar4"];
    NSArray *  _nameSelectedArray = @[@"tabBarSelected1",@"tabBarSelected2",@"tabBarSelected3",@"tabBarSelected4"];
    NSArray *array = @[@"新闻",@"布拉格依旧",@"空间",@"个人中心"];
    for (int i = 0; i  < self.tabBar.items.count; i ++) {
        
        UITabBarItem *item = self.tabBar.items[i];
        item = [item initWithTitle:array[i] image:[self createImageWithName:_nameArray[i]] selectedImage:[self createImageWithName:_nameSelectedArray[i]]];
       
        //设置item字体颜色
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
        //选中颜色
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:RGB_color(0, 145, 211, 1)} forState:UIControlStateSelected];
    }
}

-(UIImage *)createImageWithName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    //需要对图片进行特殊处理
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //自定义tabbar处理
   // [self.selectedViewController beginAppearanceTransition: YES animated: animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     //自定义tabbar处理
   //  [self.selectedViewController beginAppearanceTransition: NO animated: animated];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
     //自定义tabbar处理
  //  [self.selectedViewController endAppearanceTransition];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
     //自定义tabbar处理
    //[self.selectedViewController endAppearanceTransition];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
