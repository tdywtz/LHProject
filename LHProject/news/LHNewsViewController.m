//
//  NewsViewController.m
//  chezhiwang
//
//  Created by bangong on 16/3/18.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "LHNewsViewController.h"

@interface LHNewsViewController ()<UIScrollViewDelegate>
{
    /** 开始拖动时的偏移量 */
    CGFloat _startContentOffsetX;

}
@property (nonatomic,weak) UIViewController *showViewController;
@end

@implementation LHNewsViewController

- (instancetype)initWithParentViewController:(UIViewController *)parentViewController
{
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor clearColor];
        self.view.opaque = NO;
       // parentViewController.reusableController = self;
        parentViewController.automaticallyAdjustsScrollViewInsets = NO;
        [parentViewController addChildViewController:self];
        [parentViewController.view addSubview:self.view];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        self.scrollView.scrollsToTop = NO;
        //边界回弹
        self.scrollView.bounces = YES;
        [self.view addSubview:self.scrollView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)setSubViewControllers:(NSArray<__kindof UIViewController *> *)subViewControllers{

    _subViewControllers = subViewControllers;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*_subViewControllers.count, 0);
}

-(void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    [self showViewControllerWithIndex:_currentIndex];
}

-(void)showViewControllerWithIndex:(NSInteger)index{
  
    if (index >= 0 && index < _subViewControllers.count) {
   
        UIViewController  *vc = (UIViewController *)_subViewControllers[index];
      
        if (vc.view.superview) {
           self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width*index, 0);
            return;
        }
        [self addChildViewController:vc];
        [self.scrollView addSubview:vc.view];
        
        //视图显示
        [vc viewApper];
        //视图不显示
        [self.showViewController viewDisappear];
        self.showViewController = vc;
        vc.view.frame = CGRectMake(self.scrollView.frame.size.width*index, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
         self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width*index, 0);
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
     _startContentOffsetX = scrollView.contentOffset.x;
}

//**滑动结束*/
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndScroll:)]) {
        [self.delegate scrollViewDidEndScroll:self.scrollView.contentOffset.x/self.scrollView.frame.size.width];
    }
   
    self.currentIndex = self.scrollView.contentOffset.x/self.scrollView.frame.size.width;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 记录offsetX
    CGFloat offsetX = self.scrollView.contentOffset.x;
    
    CGFloat width = self.scrollView.frame.size.width;

    // 记录进度
    CGFloat progress = offsetX / width;

    _currentIndex = offsetX /width;
    
    // 左方目前的index
    int leftCurrentIndex = offsetX / (width - 1);

    if ([self.delegate respondsToSelector:@selector(scrollViewProgress:)]) {
         [self.delegate scrollViewProgress:progress];
    }
   
    // 边界直接返回
    if ((_startContentOffsetX / width) == progress) return;
//    
//    if (self.scrollView.dragging) {
//        return;
//    }
//    [_subViewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (_startContentOffsetX < width) {
//            if (_currentIndex >= idx) return;
//            
//            [self showViewControllerWithIndex:_currentIndex+1 scroll:NO];
//        } else {
//            [self showViewControllerWithIndex:leftCurrentIndex scroll:NO];
//        }
//    }];
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
