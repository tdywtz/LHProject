//
//  LHChatBaseCell.m
//  chat
//
//  Created by luhai on 16/1/10.
//  Copyright © 2016年 luhai. All rights reserved.
//

#import "LHChatBaseCell.h"

@implementation LHChatBaseCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI:frame];
    }
    return self;
}

-(void)makeUI:(CGRect)frame{
    _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    [self.contentView addSubview:_leftImageView];
    
    _leftNikeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 20)];
    [self.contentView addSubview:_leftNikeNameLabel];
    
    _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-50, 10, 40, 40)];
    [self.contentView addSubview:_rightImageView];
}
@end
