//
//  LHMessage.h
//  chat
//
//  Created by luhai on 16/1/9.
//  Copyright © 2016年 luhai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHUserInfo.h"
#import "xmppSetFile.h"

@interface LHMessage : NSObject

@property (nonatomic,strong) LHUserInfo *userInfo;
@property (nonatomic,copy) NSString *exten;//自定义字段
@property (nonatomic,copy) NSString *sendId;
@property (nonatomic,copy) NSString *targetId;
/** 消息方向 */
@property(nonatomic, assign) LHMessageDirection messageDirection;

@end
