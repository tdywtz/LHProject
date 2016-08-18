//
//  LHChatTextCell.m
//  chat
//
//  Created by luhai on 16/1/10.
//  Copyright © 2016年 luhai. All rights reserved.
//

#import "LHChatTextCell.h"
#import "LHTextMessage.h"

@implementation LHChatTextCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self crateUI:frame];
    }
    return self;
}

-(void)crateUI:(CGRect)frame{
    _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 40, 200, 30)];
    [self.contentView addSubview:_leftLabel];
    
    _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, frame.size.width-80-60, 30)];
    [self.contentView addSubview:_rightLabel];
    
    [_leftLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.right).offset(10);
        make.top.equalTo(self.leftNikeNameLabel.bottom);
        make.right.lessThanOrEqualTo(self.rightImageView.left);
    }];
    
    [_rightLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightImageView.left).offset(-10);
        make.top.equalTo(self.rightImageView);
        make.left.greaterThanOrEqualTo(self.leftImageView.right);
    }];
}

-(void)setMessage:(LHTextMessage *)message{
    if (_message != message) {
        _message = message;
        
        if (_message.messageDirection == MessageDirection_SEND) {
            self.rightImageView.image = _message.userInfo.image;
            self.rightLabel.text = _message.content;
            
            self.leftImageView.hidden = YES;
            self.leftNikeNameLabel.hidden = YES;
            self.leftLabel.hidden = YES;
            
            self.rightImageView.hidden = NO;
            self.rightLabel.hidden = NO;
        }else{
            self.leftImageView.image = _message.userInfo.image;
            self.leftNikeNameLabel.text = _message.userInfo.nikeName;
            self.leftLabel.text = _message.content;
            
            self.leftImageView.hidden = NO;
            self.leftNikeNameLabel.hidden = NO;
            self.leftLabel.hidden = NO;
            
            self.rightImageView.hidden = YES;
            self.rightLabel.hidden = YES;
        }
    }
}


@end
