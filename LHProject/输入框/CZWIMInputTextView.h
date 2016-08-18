

//
//  ActIMInputTextView.h
//  ArtBox
//
//  Created by zhaoguogang on 10/31/14.
//  Copyright (c) 2014 zhaoguogang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZWIMInputTextView : UITextView

/**
 *  提示用户输入的标语
 */
@property (nonatomic, copy) NSString *placeHolder;

/**
 *  标语文本的颜色
 */
@property (nonatomic, strong) UIColor *placeHolderTextColor;


@end

@interface NSString (ActIMInputTextView)

- (NSString *)stringByTrimingWhitespace;

@end
