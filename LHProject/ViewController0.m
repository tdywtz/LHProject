//
//  ViewController0.m
//  LHProject
//
//  Created by bangong on 16/3/31.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "ViewController0.h"
#import "LHNewsViewController.h"
#import "LHToolView.h"
#import "NewsListViewController.h"
#import "TestObject.h"

@interface ViewController0 ()<LHNewsViewControllerDelegate,LHToolViewDelegate>
{
    LHToolView *toolView;
    LHNewsViewController *newsView;
}
@end

@implementation ViewController0

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self crateNews];
    NSDictionary *dcit = @{@"name":@"tianya",@"title":@"1090",@"content":@"I love",@"cellHeight":@"123"};
    TestObject *model = [[TestObject alloc] initWithDictionary:dcit];
    NSLog(@"====%@",model.name);
    NSLog(@"====%@",[model getDictionary]);
    
}

- (void)crateNews{
    toolView = [[LHToolView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    toolView.delegate = self;
    toolView.titleArray = @[@"最新",@"行业",@"新车",@"谍照",@"评测",@"导购",@"召回",
                            @"用车",@"零部件",@"缺陷报道",@"分析报告",@"投诉销量比",
                            @"可靠性调查",@"满意度调查"];
    toolView.currentIndex = 0;
    self.navigationItem.titleView = toolView;
    
    
    NSMutableArray *array = [NSMutableArray new];
    NSArray *typeArray = @[@"0",@"1",@"5",@"14",@"4",@"15",@"2",@"13",@"6",@"9",@"16",@"17",@"18",@"19",@""];
    for (int i = 0; i < toolView.titleArray.count;  i ++) {
        NewsListViewController *vc = [[NewsListViewController alloc] init];
        
        if (i == 0) {
            vc.tableHeaderViewHave = YES;
        }
        vc.urlString =  [NSString stringWithFormat:@"http://m.12365auto.com/server/forAppWebService.ashx?act=news&style=%@%@",typeArray[i],@"&p=%ld&s=%ld"];
        [array addObject:vc];
    }
    //    NewsInvestigateViewController *investigate = [[NewsInvestigateViewController alloc] init];
    //    [array addObject:investigate];
    
    newsView = [[LHNewsViewController alloc] initWithParentViewController:self];
    newsView.delegate = self;
    newsView.subViewControllers = array;
    newsView.currentIndex = 0;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)((double)2 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(WIDTH, HEIGHT), YES, 0);     //设置截屏大小
        [[self.navigationController.view layer] renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIImageWriteToSavedPhotosAlbum(viewImage, self, nil, nil);
    });

}
#pragma mark -LHNewsViewControllerDelegate
-(void)scrollViewDidEndScroll:(NSInteger)index{
    toolView.currentIndex = index;
}
#pragma mark -LHToolViewDelegate
-(void)selectedButton:(NSInteger)index{
    newsView.currentIndex = index;
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
