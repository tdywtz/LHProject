//
//  LHMenuController.h
//  LHProject
//
//  Created by bangong on 16/4/13.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHMenuItem : UIButton

@property (nonatomic,strong) UIImageView *itemImage;
@property (nonatomic,strong) UILabel     *itemTitleLabel;

-(instancetype)initWithTitle:(NSString *)title andImage:(UIImage *)image;

@end

@interface LHMenuController : UIViewController
/**动画执行时间*/
@property (nonatomic,assign) NSTimeInterval duration;
/**动画延迟执行时间*/
@property (assign, nonatomic) CFTimeInterval beginTime;
/**按钮大小*/
@property (nonatomic,assign) CGSize  itemSize;
/**
 * 列数在[3,5]区间
 */
@property (nonatomic,assign) NSInteger queues;
/**行距*/
@property (nonatomic,assign) CGFloat lineSpacing;

@property (nonatomic,strong) NSArray<__kindof LHMenuItem *> *items;


-(void)setBluffImageWithView:(UIView *)view;
@end
