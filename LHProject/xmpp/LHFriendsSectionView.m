//
//  LHFriendsSectionView.m
//  LHProject
//
//  Created by luhai on 16/3/31.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "LHFriendsSectionView.h"

@implementation LHFriendsSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = colorViewBackColor;
        self.nameLabel = [[UILabel alloc] init];
        self.numberLabel = [[UILabel alloc] init];
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
        
        [self addSubview:self.nameLabel];
        [self addSubview:self.numberLabel];
        [self addSubview:lineView];
        
        [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.centerY.equalTo(0);
        }];
        
        [self.numberLabel makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.equalTo(0);
            make.right.equalTo(-15);
        }];
        
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.height.equalTo(1);
        }];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)tap:(UITapGestureRecognizer *)tap{
    
    self.open = !self.open;
    [self.delegate clickSectionView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
