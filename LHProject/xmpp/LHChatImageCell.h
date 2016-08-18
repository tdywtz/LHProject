//
//  LHChatImageCell.h
//  LHProject
//
//  Created by luhai on 16/4/4.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "LHChatBaseCell.h"
#import "LHImageMessage.h"

@interface LHChatImageCell : LHChatBaseCell

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) LHImageMessage *imageMessage;
@end
