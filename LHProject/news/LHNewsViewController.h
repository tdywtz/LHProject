//
//  NewsViewController.h
//  chezhiwang
//
//  Created by bangong on 16/3/18.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LHNewsViewControllerDelegate <NSObject>
@optional
//**scrollView滑动停止*/
-(void)scrollViewDidEndScroll:(NSInteger)index;

//**滑动进度*/
-(void)scrollViewProgress:(CGFloat)progress;
@end

@interface LHNewsViewController : UIViewController

//代理
@property (nonatomic,weak) id<LHNewsViewControllerDelegate> delegate;
/**
 *  滑动视图
 */
@property (nonatomic,strong) UIScrollView *scrollView;
 /** 子视图控制器 */
@property (nonatomic,strong) NSArray <__kindof UIViewController*> *subViewControllers;
 /** 索引 */
@property (nonatomic,assign) NSInteger currentIndex;

//**构造方法*/
- (instancetype)initWithParentViewController:(UIViewController *)parentViewController;

@end
