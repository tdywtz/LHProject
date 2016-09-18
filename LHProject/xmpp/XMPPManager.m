//
//  XMPPManager.m
//  LHProject
//
//  Created by bangong on 16/3/31.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "XMPPManager.h"

#import "XMPP.h"
#import "XMPPLogging.h"
//断点续传
#import "XMPPReconnect.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPMessageArchiving.h"
#import "XMPPMessageArchivingCoreDataStorage.h"

#import "LHTextMessage.h"
#import "LHImageMessage.h"
//打印信息
#import "DDLog.h"
#import "DDTTYLogger.h"


#import <XMPPMessage+XEP_0184.h>

#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

static XMPPManager *shareManager = nil;

@interface XMPPManager ()

- (void)setupStream;
- (void)teardownStream;

- (void)goOnline;
- (void)goOffline;

@end

@implementation XMPPManager
{
    XMPPStream *xmppStream;
    //断点续传
    XMPPReconnect *xmppReconnect;
    //花名册
    XMPPRoster *xmppRoster;
    XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPvCardCoreDataStorage *xmppvCardStorage;
    //名片模型
    XMPPvCardTempModule *xmppvCardTempModule;
    XMPPvCardAvatarModule *xmppvCardAvatarModule;
    //消息
    XMPPMessageArchiving                *xmppMessageArchivingModule;
    XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;
    //
    XMPPCapabilities *xmppCapabilities;
    XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
    
    NSString *_password;
    
    BOOL customCertEvaluation;
    
    BOOL isXmppConnected;
    BOOL allowSelfSignedCertificates;
    BOOL allowSSLHostNameMismatch;
}

+(XMPPManager *)shareManager{
       static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            shareManager = [[self alloc] init];
            [shareManager setupStream];
        });
    return shareManager;
}


#pragma mark 好友列表
- (NSArray*)friendsList:(void(^)(BOOL success))block{

    NSManagedObjectContext *context = [xmppRosterStorage mainThreadManagedObjectContext];
    NSEntityDescription*entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject" inManagedObjectContext:context];
    NSLog(@"----%@",xmppStream.myJID.user);
    NSString*currentJid=[NSString stringWithFormat:@"%@@%@",xmppStream.myJID.user,xmppStream.myJID.domain];
    //谓词搜索条件为streamBareJidStr关键词
    NSLog(@"%@",currentJid);


    NSPredicate*predicate=[NSPredicate predicateWithFormat:@"streamBareJidStr==%@",currentJid];
    NSFetchRequest*request=[[NSFetchRequest alloc]init];
    [request setEntity:entity];
    [request setPredicate:predicate];//筛选条件
    NSError*error;
    NSArray*friends=[context executeFetchRequest:request error:&error];//从数据库中取出数据
    NSMutableArray*guanzhu=[NSMutableArray arrayWithCapacity:0];
    NSMutableArray*beiguanzhu=[NSMutableArray arrayWithCapacity:0];
    NSMutableArray*duifang=[NSMutableArray arrayWithCapacity:0];
    NSMutableArray*haoyou=[NSMutableArray arrayWithCapacity:0];
    
    for (XMPPUserCoreDataStorageObject*object in friends) {
        NSRange range = [object.jidStr rangeOfString:@"@"];
        if (range.location == LONG_MAX) {
            break;
        }
        LHUserInfo *userInfo = [[LHUserInfo alloc ] init];
        userInfo.userId   = [object.jidStr substringToIndex:range.location];
        userInfo.nikeName = object.nickname;
        userInfo.image    = object.photo;
        userInfo.subscription = object.subscription;
        
        if ([object.subscription isEqualToString:@"to"]) {
            [guanzhu addObject:userInfo];
            
        }else{
            if ([object.subscription isEqualToString:@"from"]) {
                [beiguanzhu addObject:userInfo];
            }else{
                if ([object.subscription isEqualToString:@"none"]) {
                    [duifang addObject:userInfo];
                }else{
                    if ([object.subscription isEqualToString:@"both"]) {
                        [haoyou addObject:userInfo];
                    }
                }
            }
        }
    }
    
    
    
    NSArray*list=@[haoyou,guanzhu,beiguanzhu,duifang];
    
    /*
     @dynamic nickname;//昵称
     @dynamic displayName, primitiveDisplayName;//
     @dynamic subscription;//关注状态  from 你关注我  to  我关注对方 同意   none 我关注对方 没同意
     @dynamic ask;//发个请求
     @dynamic unreadMessages;//未读消息
     @dynamic photo;
     */
    
    return list;
    
}


#pragma mark 添加好友 可以带一个消息
-(void)addSomeBody:(NSString *)userId Newmessage:(NSString*)message
{//添加好友
    if (message) {
        XMPPMessage *mes=[XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithUser:userId domain:xmppDOMAIN resource:ZIYUANMING]];
        [mes addChild:[DDXMLNode elementWithName:@"body" stringValue:message]];
        [xmppStream sendElement:mes];
    }
    
    [xmppRoster subscribePresenceToUser:[XMPPJID jidWithUser:userId domain:xmppDOMAIN resource:ZIYUANMING]];
}

#pragma mark 删除好友
-(void)removeBuddy:(NSString *)name
{//删除好友
    XMPPJID *jid = [XMPPJID jidWithUser:name domain:xmppDOMAIN resource:ZIYUANMING];
    
    [ xmppRoster removeUser:jid];
}

#pragma mark 同意好友请求
//同意
-(void)agreeRequest:(NSString*)name
{
    XMPPJID *jid = [XMPPJID jidWithUser:name domain:xmppDOMAIN resource:ZIYUANMING];
    [xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
    
    XMPPPresence*temp=nil;
//    for (XMPPPresence*pre in subscribeArray)
//    {
//        if ([pre.from.user isEqualToString:name])
//        {
//            temp=pre;
//        }
//    }
//    
//    if (temp) {
//        [self.subscribeArray removeObject:temp];
//        
//    }
}
#pragma mark 拒绝好友请求
//拒绝
-(void)reject:(NSString*)name{
    XMPPJID *jid = [XMPPJID jidWithUser:name domain:xmppDOMAIN resource:ZIYUANMING];
    [xmppRoster rejectPresenceSubscriptionRequestFrom:jid];
    XMPPPresence*temp=nil;
//    for (XMPPPresence*pre in subscribeArray)
//    {
//        if ([pre.from.user isEqualToString:name])
//        {
//            temp=pre;
//        }
//    }
//    
//    if (temp) {
//        [self.subscribeArray removeObject:temp];
//    
//    }

}


#pragma mark - 注册账号
- (BOOL)registerWithName:(NSString *)name passWord:(NSString *)password{
    [self disconnect];
    [self connectWithJID:name password:@"admin"];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //xmppStream.myJID = [XMPPJID jidWithUser:@"971" domain:xmppDOMAIN resource:ZIYUANMING];
        NSError *erorr;
        BOOL bol =   [xmppStream registerWithPassword:password error:&erorr];
        NSLog(@"%@",@(bol));
    });



        return NO;
}

//修改密码
- (void)changePassworduseWord:(NSString *)checkPassword
{

    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:register"];
    NSXMLElement *msgXml = [NSXMLElement elementWithName:@"iq"];
    [msgXml addAttributeWithName:@"type" stringValue:@"set"];
    [msgXml addAttributeWithName:@"to" stringValue:@"serverip"];

    [msgXml addAttributeWithName:@"id" stringValue:@"change1"];

     DDXMLNode *username=[DDXMLNode elementWithName:@"username" stringValue:xmppStream.myJID.user];//不带@后缀
     DDXMLNode *password=[DDXMLNode elementWithName:@"password" stringValue:checkPassword];//要改的密码
     [query addChild:username];
     [query addChild:password];
     [msgXml addChild:query];
     NSLog(@"%@",msgXml);
     if (!isXmppConnected) {
       //  [self connect:];
     }
     [xmppStream sendElement:msgXml];
     
}


#pragma mark 个人中心
//接口   1、获得myVcard 2、设置自定义节点  3、更新myVcard
-(void)getMyVcardBlock:(void(^)(XMPPvCardTemp * card))success{
  
    XMPPvCardTemp *temp = [xmppvCardTempModule myvCardTemp];
   //  NSLog(@"===%@",[xmppvCardTempModule vCardTempForJID:[xmppStream myJID] shouldFetch:YES]);

    success(temp);
}
-(void)customVcardXML:(NSString*)Value name:(NSString*)Name myVcard:(XMPPvCardTemp *)myVcard{
   
    NSXMLElement *elem = [myVcard elementForName:(Name)];
  
    if (elem == nil) {
        elem = [NSXMLElement elementWithName:(Name)];
        [myVcard addChild:myVcard];
    }
    [elem setStringValue:(Value)];
}

-(void)upData:(XMPPvCardTemp*)vCard{
    [xmppvCardTempModule updateMyvCardTemp:vCard];
}

-(XMPPvCardTemp *)getVcardWithId:(NSString *)userId{
    XMPPJID *jid = [XMPPJID jidWithUser:userId domain:xmppDOMAIN resource:ZIYUANMING];
    XMPPvCardTemp *temp = [xmppvCardTempModule vCardTempForJID:jid shouldFetch:YES];
    return  temp;
}

//读取消息列表
-(NSArray*)messageRecord:(NSString *)targetId{
    // return [self getRecords:targetId];
    NSManagedObjectContext *context = xmppMessageArchivingCoreDataStorage.mainThreadManagedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:xmppMessageArchivingCoreDataStorage.messageEntityName inManagedObjectContext:context];
    

    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
  //  NSString *myjid = [NSString stringWithFormat:@"%@@%@",[xmppStream myJID].user,xmppDOMAIN];
    NSString *tojid = [NSString stringWithFormat:@"%@@%@",targetId,xmppDOMAIN];
    //谓词搜索当前联系人的信息
    NSPredicate*predicate=[NSPredicate predicateWithFormat:@"(bareJidStr like %@) && (streamBareJidStr like %@)",tojid, xmppStream.myJID.bare];
    //NSFetchedResultsController
    [request setEntity:entityDescription];
#pragma  mark 按照时间进行筛选
    //    NSDate *endDate = [NSDate date];
    //    NSTimeInterval timeInterval= [endDate timeIntervalSinceReferenceDate];
    //    timeInterval -=3600;
    //    NSDate *beginDate = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval] ;
    //    //对coredata进行筛选(假设有fetchRequest)
    //    NSPredicate *predicate_date =[NSPredicate predicateWithFormat:@"timestamp >= %@ AND timestamp <= %@", beginDate,endDate];
    //    [request setPredicate:predicate_date];//筛选时间
    
    [request setPredicate:predicate];//筛选条件
    NSError *error ;
    NSArray *messages = [context executeFetchRequest:request error:&error];

    return messages;
}

//信息列表
- (NSArray *)messageRecordList:(NSString *)targetId{
    NSArray *array=[self messageRecord:targetId];
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    for (XMPPMessageArchiving_Message_CoreDataObject *object in array) {
        NSString *jsonStr = object.body;
        NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (error) {
            
            NSLog(@"%@",error);
            continue;
        }
        
        LHMessageDirection MessageDirection;
        if (object.isOutgoing) {
            MessageDirection = MessageDirection_SEND;
            
        }else{
            MessageDirection = MessageDirection_RECEIVE;
        }
        // NSLog(@"%@",object);
        NSString *jidString = object.bareJidStr;
        NSRange range = [jidString rangeOfString:@"@"];
        NSString *userId = [jidString substringToIndex:range.location];
        XMPPvCardTemp *vcard = [self getVcardWithId:targetId];
      //  NSLog(@"==========%@",vcard.nickname.stringByRemovingPercentEncoding);
        LHUserInfo *info = [[LHUserInfo alloc] init];
        info.userId = userId;
        info.nikeName = vcard.nickname.stringByRemovingPercentEncoding;
        info.image = [UIImage imageWithData:vcard.photo];
        
        if ([dict[@"type"] isEqualToString:@"1"]) {
            
            LHTextMessage *textMessage = [[LHTextMessage alloc] init];
            textMessage.content = dict[@"content"];
            textMessage.messageDirection = MessageDirection;
            textMessage.userInfo = info;
            [results addObject:textMessage];
        }else if ([dict[@"type"] isEqualToString:@"2"]){
            
            LHImageMessage *imageMessage = [[LHImageMessage alloc] init];
            NSData *data = [[NSData alloc] initWithBase64EncodedString:dict[@"content"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
            imageMessage.image = [UIImage imageWithData:data];
            imageMessage.messageDirection = MessageDirection;
            imageMessage.userInfo = info;
            [results addObject:imageMessage];
        }
    }

    return results;
}

//发送文字消息
-(LHTextMessage *)sendTextMessageWithTarget:(NSString*)target
                         message:(NSString *)message
                            type:(LHConversationType)type{
    
    NSDictionary *dict = @{@"type":@"1",@"content":message};
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonstr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self sendMessageWithJID:target message:jsonstr];

    LHUserInfo *info = [[LHUserInfo alloc] init];
   // xmppStream.myJID

    LHTextMessage *textMessage = [[LHTextMessage alloc] init];
    textMessage.content = message;
    textMessage.messageDirection = MessageDirection_SEND;
    textMessage.userInfo = info;

    return textMessage;

}

//发送图片消息
-(LHImageMessage *)sendImageMessageWithTarget:(NSString *)target
                            image:(UIImage *)image
                             type:(LHConversationType)type{
    
    NSData *data = UIImageJPEGRepresentation(image, 1);
    NSString *str = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSDictionary *dict = @{@"type":@"2",@"content":str};
    
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonstr = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
    
    [self sendMessageWithJID:target message:jsonstr];

    LHImageMessage *imageMessage = [[LHImageMessage alloc] init];
    imageMessage.image = image;
    imageMessage.targetId = target;
   // imageMessage.sendId =

    return imageMessage;
}

#pragma mark 发送消息
//发送消息
-(void)sendMessageWithJID:(NSString*)targetId message:(NSString*)message{
    
    XMPPMessage *mes=[XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithUser:targetId domain:xmppDOMAIN resource:ZIYUANMING]];
    [mes addChild:[DDXMLNode elementWithName:@"body" stringValue:message]];
    
    //执行发送消息
    [xmppStream sendElement:mes];
    
#pragma mark  发送消息没有完成的地方
    //三
    
    //判断发送消息是否成功
    
    
    //进行广播
    //  [[NSNotificationCenter defaultCenter]postNotificationName:kXMPPNewMsgNotifaction object:nil];
}

/****************************/
#pragma mark 消息发送完成 有待测试
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
      NSLog(@"消息发送完成 ");
}
#pragma mark 消息发送失败 有待测试
- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error{
     NSLog(@"消息发送失败 %@",error);
}


#pragma mark - 链接服务器
- (BOOL)connectWithJID:(NSString *)jid password:(NSString *)password
{
    if (![xmppStream isDisconnected]) {
        return YES;
    }

    if (jid == nil || password == nil) {
        return NO;
    }
    
   // [xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
     [xmppStream setMyJID:[XMPPJID jidWithUser:jid domain:xmppDOMAIN resource:ZIYUANMING]];
    _password = password;

    NSError *error = nil;
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
                                                            message:@"See console for error details."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
      
     // DDLogError((@"Error connecting: %@", error);
                  DDLogInfo(@"dsf%@",error);
        return NO;
    }
    
    return YES;
}

- (void)disconnect
{
    [self goOffline];
    [xmppStream disconnect];
}


#pragma mark -  //设置XMPP流
- (void)setupStream
{
    NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
    //设置XMPP流
    // xmppstream是所有活动的基础类。
    //一切插入xmppstream，如模块/扩展和代表。
    xmppStream = [[XMPPStream alloc] init];
    
#if !TARGET_IPHONE_SIMULATOR
    {
        //想要XMPP在后台运行？
       
        // ps模拟器不支持后台吗。当你试着在模拟器上设置相关的属性时，它就失败了。
        //和当你在模拟器上的应用程序，
        //它只是队列网络流量直到应用前景又。我们都在耐心等待一个固定的苹果。
        //如果你在模拟器上做enablebackgroundingonsocket，
        //你将仅仅从XMPP堆栈时不能设置属性查看错误信息。
        xmppStream.enableBackgroundingOnSocket = YES;
    }
#endif
    //安装重新连接
    //
    //“意外断开”和xmppreconnect模块监测
    //自动重新连接为你而流。
    //有一大堆信息在xmppreconnect头文件。
    xmppReconnect = [[XMPPReconnect alloc] init];
    
    //设置名册
    // / /
    // xmpproster柄名册相关的XMPP协议的东西。对名册的存储进行抽象。你可以使用任何你想要的存储机制。您可以将它存储在内存中，或使用核心数据，并将其存储在磁盘上，或者使用核心数据存储在内存中存储，
    //或设置自己的使用原始的SQLite，或创建自己的存储机制。你可以这样做，但你喜欢！这是你的申请。
    //但您需要提供一些存储设施的名册。
    xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    //	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithInMemoryStore];
    
    xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];

    xmppRoster.autoFetchRoster = YES;
    xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;

    //支持vCard的设置
    //《阿凡达》/《vCard模块厂在结合与标准vCard温度模块下载到用户的avatars。。。。。。。
    // xmpproster会自动integrate与xmppvcardavatarmodule到高速缓存中的roster roster新月。
    xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
    
    xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
//    
    //设置功能
    // / /
    // xmppcapabilities模块处理所有复杂的散列的上限协议（xep-0115）。当其他客户在网络上播放他们的存在
    //他们包括关于他们的客户支持什么功能（音频，视频，文件传输等）的信息。你可以想象，这个列表开始变得非常大。这是哈希的东西进场的地方。大多数人在同一个客户机上运行相同的版本，将有相同的功能列表。协议定义了一种标准化的方法来哈希列表的功能。
    // / /客户端广播的小哈希，而不是大名单。
    // xmppcapabilities协议自动处理弄清楚这些词的意思，
    //和持久存储的哈希值，所以查找不需要在未来。
    //和/或类似于名册，该模块的存储是抽象的。强烈鼓励你坚持在会议上的信息。
    // / /
    // xmppcapabilitiescoredatastorage是理想的解决方案。
    //它也可以共享在多个流，进一步减少哈希查找。
    xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
    
    xmppCapabilities.autoFetchHashedCapabilities = YES;
    xmppCapabilities.autoFetchNonHashedCapabilities = NO;

    //激活XMPP协议模块
    [xmppReconnect         activate:xmppStream];
    [xmppRoster            activate:xmppStream];
    [xmppvCardTempModule   activate:xmppStream];
    [xmppvCardAvatarModule activate:xmppStream];
    [xmppCapabilities      activate:xmppStream];
    
    // Add ourself as a delegate to anything we may be interested in
    //添加自己为代表任何我们可能会感兴趣
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppvCardTempModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
   
    //可选：
    // / /用适当的域和端口替换我。下面的例子是一个典型的谷歌讨论帐户的设置。
    //如果你不提供一个主机名，然后它会自动使用JID解决（下）。
    //例如，如果你提供一个JID喜欢user@quack.com/rsrc”
    //然后XMPP框架将遵循XMPP协议规范，并quack.com做SRV查找。
    //如果你不指定一个hostport，然后将使用默认（5222）。
    [xmppStream setHostName:xmppDOMAIN];
    [xmppStream setHostPort:5222];
    
    //您可能需要改变这些设置取决于您连接到的服务器
    customCertEvaluation = YES;
    
    xmppMessageArchivingCoreDataStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    xmppMessageArchivingModule = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:xmppMessageArchivingCoreDataStorage];
    [xmppMessageArchivingModule setClientSideMessageArchivingOnly:YES];
    [xmppMessageArchivingModule activate:xmppStream];
    [xmppMessageArchivingModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    
    [xmppRosterStorage mainThreadManagedObjectContext];
}

- (void)teardownStream
{
    [xmppStream removeDelegate:self];
    [xmppRoster removeDelegate:self];
    
    [xmppReconnect         deactivate];
    [xmppRoster            deactivate];
    [xmppvCardTempModule   deactivate];
    [xmppvCardAvatarModule deactivate];
    [xmppCapabilities      deactivate];
    
    [xmppStream disconnect];
    
    xmppStream = nil;
    xmppReconnect = nil;
    xmppRoster = nil;
    xmppRosterStorage = nil;
    xmppvCardStorage = nil;
    xmppvCardTempModule = nil;
    xmppvCardAvatarModule = nil;
    xmppCapabilities = nil;
    xmppCapabilitiesStorage = nil;
}

- (void)goOnline
{
    XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
    
    NSString *domain = [xmppStream.myJID domain];
    
    //Google set their presence priority to 24, so we do the same to be compatible.
    
    if([domain isEqualToString:@"gmail.com"]
       || [domain isEqualToString:@"gtalk.com"]
       || [domain isEqualToString:@"talk.google.com"])
    {
        NSXMLElement *priority = [NSXMLElement elementWithName:@"priority" stringValue:@"24"];
        [presence addChild:priority];
    }
    
    [xmppStream sendElement:presence];
}

//下线通知
- (void)goOffline
{
//    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
//    
//    [xmppStream sendElement:presence];

    XMPPIQ *iq = [[XMPPIQ alloc] initWithXMLString:[NSString stringWithFormat:@"<presence from='%@'><priority>1</priority></presence>",xmppStream.myJID.bare]error:nil];
    [xmppStream sendElement:iq];
}


#pragma mark Core Data
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSManagedObjectContext *)managedObjectContext_roster
{
    return [xmppRosterStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_capabilities
{
    return [xmppCapabilitiesStorage mainThreadManagedObjectContext];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    NSString *expectedCertName = [xmppStream.myJID domain];
    if (expectedCertName)
    {
        settings[(NSString *) kCFStreamSSLPeerName] = expectedCertName;
    }
    
    if (customCertEvaluation)
    {
        settings[GCDAsyncSocketManuallyEvaluateTrust] = @(YES);
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceiveTrust:(SecTrustRef)trust
 completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    // The delegate method should likely have code similar to this,
    // but will presumably perform some extra security code stuff.
    // For example, allowing a specific self-signed certificate that is known to the app.
    
    dispatch_queue_t bgQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(bgQueue, ^{
        
        SecTrustResultType result = kSecTrustResultDeny;
        OSStatus status = SecTrustEvaluate(trust, &result);
        
        if (status == noErr && (result == kSecTrustResultProceed || result == kSecTrustResultUnspecified)) {
            completionHandler(YES);
        }
        else {
            completionHandler(NO);
        }
    });
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
     NSLog(@"连接成功%@",_password);
    isXmppConnected = YES;
    
    NSError *error = nil;
    
    if (![xmppStream authenticateWithPassword:_password error:&error])
    {
        DDLogError(@"Error authenticating: %@", error);
    }
}

- (void)xmppStreamWillConnect:(XMPPStream *)sender
{
    //将要开始连接
    NSLog(@"将要开始连接");
}

//登录成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    [self goOnline];
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    NSLog(@"完成认证，发送在线状态");
    [xmppRoster fetchRoster];
}

//登录失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    NSLog(@"认证错误");
}

//注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注册成功"
                                                        message:@"注册成功"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];

}
//注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    NSLog(@"%@",error);
    NSLog(@"%@",[[error elementForName:@"error"] stringValue]);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注册失败"
                                                        message:@"注册失败"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    return NO;
}

#pragma mark -//收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    // A simple example of inbound message handling.
   NSLog(@"%@",message);

    if ([message isChatMessageWithBody])
    {
        XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[message from]
                                                                 xmppStream:xmppStream
                                                       managedObjectContext:[self managedObjectContext_roster]];
        
        NSString *body = [[message elementForName:@"body"] stringValue];
        NSString *displayName = [user displayName];
        NSString *received = [[message elementForName:@"received"] stringValue];

        NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSInteger type = [dict[@"type"] integerValue];
        if (type == 1) {

            NSLog(@"===%@",received);
          
            NSLog(@"+++%@",displayName);
        }else if (type == 2){
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:dict[@"content"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            NSLog(@"%@",image);
        }else if (type == 3){
            
        }

        UILocalNotification *notification = [[UILocalNotification alloc] init];
        // 设置触发通知的时间
//        NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:alertTime];
//        NSLog(@"fireDate=%@",fireDate);
//
//        notification.fireDate = fireDate;
//        // 时区
//        notification.timeZone = [NSTimeZone defaultTimeZone];
//        // 设置重复的间隔
//        notification.repeatInterval = kCFCalendarUnitSecond;

        // 通知内容
        notification.alertBody =  @"该起床了...";
        notification.applicationIconBadgeNumber = 1;
        // 通知被触发时播放的声音
        notification.soundName = UILocalNotificationDefaultSoundName;
        // 通知参数
        NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"开始学习iOS开发了" forKey:@"key"];
        notification.userInfo = userDict;

        // ios8后，需要添加这个注册，才能得到授权
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                     categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            // 通知重复提示的单位，可以是天、周、月
            notification.repeatInterval = NSCalendarUnitDay;
        } else {
            // 通知重复提示的单位，可以是天、周、月
            notification.repeatInterval = NSDayCalendarUnit;  
        }  
        
        // 执行通知注册  
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];

        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
        {

            NSRange range = [displayName rangeOfString:@"@"];
            NSString *userid = [displayName substringToIndex:range.location];
            UIAlertController *alet = [UIAlertController alertControllerWithTitle:@"同意" message:@"同意" preferredStyle:UIAlertControllerStyleAlert];
          
//            UIAlertAction *act = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//          [xmppRoster acceptPresenceSubscriptionRequestFrom:[message from] andAddToRoster:YES];
//               // [[XMPPManager shareManager] agreeRequest:userid];
//                NSLog(@"%@",userid);
//            }];
//            [alet addAction:act];
//            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alet animated:YES completion:nil];

        }
        else
        {
            // We are not active, so use a local notification instead
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.alertAction = @"Ok";
            localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",displayName,body];
            
            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
        }
    }

    [self.delegate receiveMessage:nil];
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    //取得好友状态
    NSString *presenceType = [NSString stringWithFormat:@"%@", [presence type]]; //online/offline
    //当前用户
    //    NSString *userId = [NSString stringWithFormat:@"%@", [[sender myJID] user]];
    //在线用户
    NSString *presenceFromUser =[NSString stringWithFormat:@"%@", [[presence from] user]];
    NSLog(@"presenceType:%@",presence);
    NSLog(@"用户:%@",presenceFromUser);
    //这里再次加好友
  
    if ([presenceType isEqualToString:@"subscribed"]) {
        XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@",[presence from]]];
        [xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
    }

    DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    if (!isXmppConnected)
    {
        DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPRosterDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppRoster:(XMPPRoster *)sender didReceiveBuddyRequest:(XMPPPresence *)presence
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[presence from]
                                                             xmppStream:xmppStream
                                                   managedObjectContext:[self managedObjectContext_roster]];
    
    NSString *displayName = [user displayName];
    NSString *jidStrBare = [presence fromStr];
    NSString *body = nil;
    
    if (![displayName isEqualToString:jidStrBare])
    {
        body = [NSString stringWithFormat:@"Buddy request from %@ <%@>", displayName, jidStrBare];
    }
    else
    {
        body = [NSString stringWithFormat:@"Buddy request from %@", displayName];
    }
    
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
                                                            message:body
                                                           delegate:nil 
                                                  cancelButtonTitle:@"Not implemented"
                                                  otherButtonTitles:nil];
        [alertView show];
    } 
    else 
    {
        // We are not active, so use a local notification instead
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.alertAction = @"Not implemented";
        localNotification.alertBody = body;
        
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }
}

- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    //取得好友状态
    NSString *presenceType = [NSString stringWithFormat:@"%@", [presence type]]; //online/offline
    //请求的用户
    NSString *presenceFromUser =[NSString stringWithFormat:@"%@", [[presence from] user]];
//    NSLog(@"presenceType:%@",presenceType);
//    
//    NSLog(@"presence2:%@  sender2:%@",presence,sender);
    
    XMPPJID *jid = [XMPPJID jidWithString:presenceFromUser];
   
   // jid = [XMPPJID jidWithUser:[presence from]  domain:xmppDOMAIN resource:ZIYUANMING];
    NSLog(@"=====================%@",jid.user);
    [xmppRoster acceptPresenceSubscriptionRequestFrom:[presence from] andAddToRoster:YES];
    NSLog(@"fa");
}

@end
