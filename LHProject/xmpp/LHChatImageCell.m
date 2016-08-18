
//
//  LHChatImageCell.m
//  LHProject
//
//  Created by luhai on 16/4/4.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "LHChatImageCell.h"

@implementation LHChatImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageView];
        
        [self.imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.leftNikeNameLabel.bottom).offset(2);
            make.left.equalTo(self.leftImageView.right).equalTo(10);
            make.size.equalTo(CGSizeMake(100, 100));
        }];
    }
    return self;
}

-(void)setImageMessage:(LHImageMessage *)imageMessage{
    NSLog(@"++++++++%@",_imageMessage.userInfo.nikeName);
//    if (_imageMessage == imageMessage) {
//        return;
//    }
    self.imageView.backgroundColor = [UIColor redColor];
    _imageMessage = imageMessage;
    
    
    self.imageView.image = _imageMessage.image;
    if (_imageMessage.messageDirection == MessageDirection_SEND) {
        self.rightImageView.image = _imageMessage.userInfo.image;
        [self.imageView remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.rightImageView.left).offset(-10);
            make.top.equalTo(self.rightImageView);
            make.size.equalTo(CGSizeMake(100, 100));
        }];
        
        self.leftImageView.hidden = YES;
        self.leftNikeNameLabel.hidden = YES;
     
        
        self.rightImageView.hidden = NO;
    
    }else{
        self.leftImageView.image = _imageMessage.userInfo.image;
        self.leftNikeNameLabel.text = _imageMessage.userInfo.nikeName;
        [self.imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.leftNikeNameLabel.bottom).offset(2);
            make.left.equalTo(self.leftImageView.right).equalTo(10);
            make.size.equalTo(CGSizeMake(100, 100));
        }];
 
        self.leftImageView.hidden = NO;
        self.leftNikeNameLabel.hidden = NO;
    
        
        self.rightImageView.hidden = YES;
    }

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
