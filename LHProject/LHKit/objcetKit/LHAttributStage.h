//
//  LHAttributStage.h
//  lhproject
//
//  Created by bangong on 16/3/23.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LHAttributStage : NSObject

/**文字颜色 */
@property (nonatomic,strong) UIColor *textColor;

/**文字大小*/
@property (nonatomic,strong) UIFont *textFont;

/**下划线样式*/
@property (nonatomic,assign) NSUnderlineStyle UnderlineStyle;

/**字距（0无效）*/
@property (nonatomic,assign) CGFloat characterSpace;

#pragma mark - 段落样式
/**  行距*/
@property(NS_NONATOMIC_IOSONLY) CGFloat lineSpacing;

/**段落距离*/
@property(NS_NONATOMIC_IOSONLY) CGFloat paragraphSpacing;

/**对其方式*/
@property(NS_NONATOMIC_IOSONLY) NSTextAlignment alignment;

/** 段落首行距离左边长度*/
@property(NS_NONATOMIC_IOSONLY) CGFloat firstLineHeadIndent;

/**除去首行段落距离左边长度 */
@property(NS_NONATOMIC_IOSONLY) CGFloat headIndent;

/**段落宽度*/
@property(NS_NONATOMIC_IOSONLY) CGFloat tailIndent;

/**换行方式*/
@property(NS_NONATOMIC_IOSONLY) NSLineBreakMode lineBreakMode;

/**最小行高*/
@property(NS_NONATOMIC_IOSONLY) CGFloat minimumLineHeight;

/**最大行高*/
@property(NS_NONATOMIC_IOSONLY) CGFloat maximumLineHeight;

/**<#Description#>*/
@property(NS_NONATOMIC_IOSONLY) NSWritingDirection baseWritingDirection;

/**行高的倍数*/
@property(NS_NONATOMIC_IOSONLY) CGFloat lineHeightMultiple;

/**段落前空白距离*/
@property(NS_NONATOMIC_IOSONLY) CGFloat paragraphSpacingBefore;

/**<#Description#>*/
@property(NS_NONATOMIC_IOSONLY) float hyphenationFactor;

@end
