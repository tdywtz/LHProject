//
//  LHChatTextCell.h
//  chat
//
//  Created by luhai on 16/1/10.
//  Copyright © 2016年 luhai. All rights reserved.
//

#import "LHChatBaseCell.h"
@class LHTextMessage;

@interface LHChatTextCell : LHChatBaseCell

@property (nonatomic,strong) UILabel *leftLabel;
@property (nonatomic,strong) UILabel *rightLabel;

@property (nonatomic,strong) LHTextMessage *message;
@end
