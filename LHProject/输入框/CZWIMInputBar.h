//
//  CZWIMInputBar.h
//  autoService
//
//  Created by bangong on 16/1/4.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZWIMInputTextView.h"

typedef NS_ENUM(NSUInteger, CZWIMInputBarType) {
    CZWIMInputBarTypeVoice = 0,
    CZWIMInputBarTypeText,
    CZWIMInputBarTypeEmotion,
    CZWIMInputBarTypeMore,
};

@protocol CZWIMInputBarDelegate <NSObject>
@optional
- (void)CZWIMInputBarDidSendTextAction:(NSString *)aText;
- (void)CZWIMInputBarFrameChangeValue:(CGRect)frame;

///
-(void)selectedButton:(NSInteger *)index;

@end

@interface CZWIMInputBar : UIView

@property (nonatomic, strong) CZWIMInputTextView *textView;
@property (nonatomic, weak) id<CZWIMInputBarDelegate> delegate;

@property (nonatomic, assign) BOOL expand;
@property (nonatomic, assign) CZWIMInputBarType type;
@property (nonatomic, assign) BOOL hideKeyboardWhenSend; // 默认为YES
@property (nonatomic, assign) CGFloat keyboradHeight;

/**
 *  是否允许发送语音
 */
@property (nonatomic, assign) BOOL allowsSendVoice; // default is YES


/**
 *  是否支持发送表情
 */
@property (nonatomic, assign) BOOL allowsSendFace; // default is YES

/**
 *  是否支持发送More
 */
@property (nonatomic, assign) BOOL allowsSendMore; // default is YES

/**
 *  获取最大行数
 *
 *  @return 返回最大行数
 */
+ (CGFloat)maxLines;

/*
 *  面板高度
 */
- (CGFloat)boradHeight;

@end
