//
//  LHPhotosController.m
//  photos
//
//  Created by bangong on 16/1/18.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "LHPhotosController.h"
#import "LHPhotosGroupsViewController.h"


@interface LHPhotosController ()

@end

@implementation LHPhotosController

- (instancetype)init
{
    
    LHPhotosGroupsViewController *photosView = [[LHPhotosGroupsViewController alloc] init];
    self = [super  initWithRootViewController:photosView];
  
    _maxNumber = 1;
    return self;
}

-(void)resultPhotos:(void (^)(NSArray<__kindof LHAsset *> *))block{
    self.photos = block;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
