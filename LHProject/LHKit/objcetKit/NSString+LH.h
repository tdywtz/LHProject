//
//  NSString+LH.h
//  lhproject
//
//  Created by bangong on 16/3/23.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (LH)
/**判断字符串是否只含有数字，大小写字母和汉字、下滑线 */
+ (BOOL)isNickName:(NSString *)nickName;

/**判断是否姓名*/
+ (BOOL)isName:(NSString *)nameStr;

/**判断是否用户名*/
+ (BOOL)isUserName:(NSString *)userNameStr;

/**过滤掉'<'、"<"、‘&’字符的 60汉字和20字符*/
+ (BOOL)isRemMsg: (NSString *)aString;

/** 判断字符串是否只还有数字，大小字母 */
+ (BOOL)isPassword:(NSString *)password;

/**判断输入是否数字（含小数点） */
+ (BOOL) isDigital:(NSString *)aString;


/**判断是否纯数字 */
+ (BOOL) isNumber:(NSString *)aString;

/**判断是否身份号*/
+ (BOOL) isIDNumber:(NSString *)aString;

/**判断字符串是否6位数字 */
+ (BOOL) isSixDigitalPassword:(NSString *)password;

/**判断字符串是否6－16位字符（大小写字符和数字）*/
+ (BOOL) isSixToThTwelvePassword:(NSString *)password;

/**是否正常银行卡号（10－32位）*/
+ (BOOL) isCardNumber:(NSString *)aString;

/**md5*/
+ (NSString *)md5Digest:(NSString *)str;

/**
 *  判断是否简单密码 modified by sunruilian
 *
 *  @param password <#password description#>
 *
 *  @return          0，不是简单密码；1，含有数字和字母外的特殊字符；
 *                   2，含有6位连续的数字或字母;3，含有6位连续的相同数字或字母
 */
+ (NSInteger) checkSimplePassword: (NSString *)password;

/**判断字符串是否非空（空字符串也为空） */
+ (BOOL)isNotNULL:(NSString *)string;

/**判断输入文字是否含有表情字符*/
+ (BOOL)isContainsEmoji:(NSString *)string;

/**邮箱格式验证*/
+ (BOOL)isEmailTest:(NSString *)email;

/**计算字符串size*/
-(CGSize)calculateTextSizeWithFont:(UIFont *)font Size:(CGSize)size;


@end





