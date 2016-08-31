//
//  XMPPManager.h
//  LHProject
//
//  Created by bangong on 16/3/31.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "XMPPFramework.h"
#import "LHUserInfo.h"
#import <XMPPvCardTemp.h>
#import "xmppSetFile.h"
#import "LHMessage.h"

@protocol XMPPManagerDelegate <NSObject>
//接收消息
-(void)receiveMessage:(LHMessage *)message;
//登录成功
- (void)loginSuccess;
//
@end

@interface XMPPManager : NSObject

@property (nonatomic,weak) id <XMPPManagerDelegate> delegate;

+ (XMPPManager *)shareManager;

//**链接服务器*/
- (BOOL)connectWithJID:(NSString *)jid password:(NSString *)password;
//**断开链接*/
- (void)disconnect;

//**获取好友列表*/
- (NSArray*)friendsList:(void(^)(BOOL success))block;
//添加好友 可以带一个消息
-(void)addSomeBody:(NSString *)userId Newmessage:(NSString*)message;
//删除好友
-(void)removeBuddy:(NSString *)name;

//处理请求
//同意
-(void)agreeRequest:(NSString*)name;
//拒绝
-(void)reject:(NSString*)name;

#pragma mark - 注册账号
- (BOOL)registerWithName:(NSString *)name passWord:(NSString *)password;

#pragma mark 个人中心
//接口   1、获得myVcard 2、设置自定义节点  3、更新myVcard
-(void)getMyVcardBlock:(void(^)(XMPPvCardTemp * card))success;
-(void)customVcardXML:(NSString*)Value name:(NSString*)Name myVcard:(XMPPvCardTemp *)myVcard;
-(void)upData:(XMPPvCardTemp*)vCard;
-(XMPPvCardTemp *)getVcardWithId:(NSString *)userId;
///
-(NSArray*)messageRecord:(NSString *)targetId;
//信息列表
- (NSArray *)messageRecordList:(NSString *)targetId;
//发送文字消息
-(void)sendTextMessageWithTarget:(NSString*)target
                         message:(NSString *)message
                            type:(LHConversationType)type;

//发送图片消息
-(void)sendImageMessageWithTarget:(NSString *)target
                            image:(UIImage *)image
                             type:(LHConversationType)type;
@end
