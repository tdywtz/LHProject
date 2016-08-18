

//服务器设置
#define xmppDOMAIN @"bangongdeimac.local"//@"1000phone.net"
#define ZIYUANMING @"IOS"


// @enum LHConversationType 会话类型
typedef NS_ENUM(NSUInteger, LHConversationType) {
    /**
     * 私聊
     */
    ConversationType_PRIVATE = 1,
    /**
     * 讨论组
     */
    ConversationType_DISCUSSION,
    /**
     * 群组
     */
    ConversationType_GROUP,
    /**
     * 聊天室
     */
    ConversationType_CHATROOM,
    /**
     *  客服(仅用于客服1.0系统。客服2.0系统使用订阅号方式，因此需要使用ConversationType_APPSERVICE会话类型，并且会话页面要是RCPublicServiceChatViewController，否则无法显示自定义菜单）
     */
    ConversationType_CUSTOMERSERVICE,
    /**
     *  系统会话
     */
    ConversationType_SYSTEM,
    /**
     *  订阅号 Custom
     */
    ConversationType_APPSERVICE, // 7
    
    /**
     *  订阅号 Public
     */
    ConversationType_PUBLICSERVICE,
    
    /**
     *  推送服务
     */
    ConversationType_PUSHSERVICE
};

//消息发送方向
typedef NS_ENUM(NSInteger,LHMessageDirection) {
    MessageDirection_SEND = 1, // false
    MessageDirection_RECEIVE // true
};


