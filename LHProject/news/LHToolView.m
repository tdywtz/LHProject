//
//  ToolView.m
//  12365auto
//
//  Created by bangong on 16/3/21.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "LHToolView.h"

@interface LHToolView ()

@property (nonatomic,strong) UIScrollView *scrollView;
//**中间层，用于计算contentSize*/
@property (nonatomic,strong) UIView *contentView;
//**保存按钮*/
@property (nonatomic,strong) NSMutableArray *items;
@end

@implementation LHToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.scrollsToTop = NO;
        [self addSubview:_scrollView];
   
        _contentView = [[UIView alloc] init];
        [_scrollView addSubview:_contentView];
    }
    return self;
}


-(void)setTitleArray:(NSArray<__kindof NSString *> *)titleArray{
    _titleArray = titleArray;
   
    for (UIView *subView in _contentView.subviews) {
        [subView removeFromSuperview];
    }
    UIButton *temp = nil;
    if (!self.items) {
        self.items = [[NSMutableArray alloc] init];
    }
    for (int i = 0; i < _titleArray.count; i ++) {
 
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.tag = 100+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        CGFloat width = [_titleArray[i] boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:button.titleLabel.font} context:nil].size.width;
        if (temp) {
            [button makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(temp.right).offset(10);
                make.centerY.equalTo(self.contentView);
                make.size.equalTo(CGSizeMake(width+20, 25));
            }];
            
        }else{
            [button makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(15);
                make.centerY.equalTo(self.contentView);
               make.size.equalTo(CGSizeMake(width+20, 25));
            }];
        }
        temp = button;
        [self.items addObject:button];
    }
    
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
        make.right.equalTo(temp.right);
    }];
}

-(void)buttonClick:(UIButton *)button{
  
        for (UIButton *btn in self.items) {
            btn.selected = NO;
        
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
        }
 
       button.titleLabel.font = [UIFont systemFontOfSize:17];
       button.selected = YES;
    
    if ([self.delegate respondsToSelector:@selector(selectedButton:)]) {
        [self.delegate selectedButton:button.tag-100];
    }
}
-(void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
 
    if (_currentIndex >= 0 && _currentIndex < self.items.count) {
    
        UIButton *bt = self.items[_currentIndex];
        [self buttonClick:bt];
        if (bt.frame.origin.x+bt.frame.size.width > self.scrollView.contentOffset.x+self.scrollView.frame.size.width) {
            [UIView animateWithDuration:0.1 animations:^{
                _scrollView.contentOffset = CGPointMake(bt.frame.size.width+bt.frame.origin.x-self.scrollView.frame.size.width, 0);
            }];
            
        }else if (bt.frame.origin.x < self.scrollView.contentOffset.x){
            [UIView animateWithDuration:0.1 animations:^{
                 _scrollView.contentOffset = CGPointMake(bt.frame.origin.x, 0);
            }];
        }
    }
}

@end
