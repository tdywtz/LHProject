//
//  NSString+LH.m
//  lhproject
//
//  Created by bangong on 16/3/23.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "NSString+LH.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (LH)
//TODO: 判断是否简单密码   modified by sunruilian
+ (NSInteger) checkSimplePassword: (NSString *)password{
    //密码只能有数字和字母组成
    //密码不能有6位连续的数字或字母
    //密码不能有6位连续的相同数字或字母
    //返回：0，不是简单密码；1，含有数字和字母外的特殊字符；
    //	   2，含有6位连续的数字或字母;3，含有6位连续的相同数字或字母
    
    NSInteger resultValue=0;
    if (![NSString isPassword: password]) {
        resultValue = 1;
        return resultValue;
    }else {
        /**
         ASCll码表:
         0-9: 48-57
         a-z: 97-122
         A-Z; 65-90
         */
        
        int incrementTag=1; //ASCll值递增标识
        int descendingTa=1; //ASCll值递减标识
        int sameTag=1;      //ASCll 值相同标识
        
        unichar char_1;
        char_1 = [password characterAtIndex:0];
        for(int i=1;i<[password length];i++)
        {
            unichar char_next = [password characterAtIndex:i];
            if (char_next == char_1) {
                sameTag++;
                incrementTag=1;
                descendingTa=1;
            }else if (char_next == char_1+1) {
                incrementTag++;
                sameTag=1;
                descendingTa=1;
            }else if (char_next == char_1-1) {
                descendingTa++;
                incrementTag=1;
                sameTag=1;
            }else {
                sameTag = 1;
                descendingTa = 1;
                incrementTag = 1;
            }
            char_1 = char_next;
            
            if (sameTag >= 6) {
                resultValue = 3;
                return resultValue;
            }else if (incrementTag >=6 || descendingTa>=6) {
                resultValue = 2;
                return resultValue;
            }
        }
    }
    
    return resultValue;
}


//TODO: 判断字符串是否只还有数字，大小字母和汉字/下划线
+ (BOOL)isNickName:(NSString *)nickName
{
    /**
     ASCll码表:
     0-9: 48-57
     a-z: 97-122
     A-Z; 65-90
     
     Unicode: char 值处于区间[19968, 19968+20902]里的，都是汉字
     */
    
    int aa=0;
    int bb=0;
    BOOL _isNickName = YES;
    for(int i=0;i<[nickName length];i++)
    {
        unichar char_nick = [nickName characterAtIndex:i];
        if ((char_nick>=48 && char_nick<=57) ||
            (char_nick>=97 && char_nick<= 122) ||
            (char_nick>=65 && char_nick<= 90)||char_nick==32) {
            aa++;
            if (aa>20) {
                //return  NO; //数字和字母不能大于20位
            }
        }else if ((char_nick>=19968 && char_nick<= 19968+20902)) {
            bb++;
            if (bb>10) {
                //return NO; //汉字不能大于10位
            }
        }else if (char_nick == '_'){
            
        }
        else {
            _isNickName = NO;
            return _isNickName;
        }
    }
    
    return _isNickName;
}
//TODO: 判断是否姓名
+ (BOOL)isName:(NSString *)nameStr{
    if (nameStr.length == 0) return NO;
    int aa=0;
    int bb=0;
    BOOL _isName = YES;
    for(int i=0;i<[nameStr length];i++)
    {
        unichar char_nick = [nameStr characterAtIndex:i];
        if ((char_nick>=97 && char_nick<= 122) ||
            (char_nick>=65 && char_nick<= 90)||char_nick==32) {
            aa++;
            if (aa>120) {
                //return  NO; //字母不能大于20位
            }
        }else if ((char_nick>=19968 && char_nick<= 19968+20902)) {
            bb++;
            if (bb>60) {
                //	return NO; //汉字不能大于10位
            }
        }else {
            _isName = NO;
            return _isName;
        }
    }
    
    return _isName;
}

//判断是否用户名
+ (BOOL)isUserName:(NSString *)userNameStr{
    if (userNameStr.length == 0) return NO;
    int aa=0;
    int bb=0;
    BOOL _isName = YES;
    for(int i=0;i<[userNameStr length];i++)
    {
        unichar char_nick = [userNameStr characterAtIndex:i];
        if ((char_nick>=97 && char_nick<= 122) ||
            (char_nick>=65 && char_nick<= 90)||char_nick==32 ||
            (char_nick >= '0' && char_nick <= '9')) {
            aa++;
            if (aa>120) {
                //return  NO; //字母不能大于20位
            }
        }else if ((char_nick>=19968 && char_nick<= 19968+20902)) {
            bb++;
            if (bb>60) {
                //	return NO; //汉字不能大于10位
            }
        }else {
            _isName = NO;
            return _isName;
        }
    }
    
    return _isName;
}

//TODO: 过滤掉'<'、"<"、‘&’字符的 60汉字和20字符
+ (BOOL)isRemMsg: (NSString *)aString{
    int aa=0;
    int bb=0;
    BOOL _isRemMsg = YES;
    for(int i=0;i<[aString length];i++)
    {
        unichar char_nick = [aString characterAtIndex:i];
        NSLog(@"%d",char_nick);
        if (char_nick == '<'||char_nick=='>'||char_nick=='&') {
            return NO;
        }else if ((char_nick>=19968 && char_nick<= 19968+20902)) {
            bb++;
            if (bb>30) {
                return NO; //汉字不能大于30位
            }
        }else {
            aa++;
            if (aa>60) {
                return  NO; //数字和字母不能大于60位
            }
        }
    }
    
    return _isRemMsg;
}


//TODO: 判断字符串是否只还有数字，大小字母
+ (BOOL)isPassword:(NSString *)password
{
    /**
     ASCll码表:
     0-9: 48-57
     a-z: 97-122
     A-Z; 65-90
     */
    
    BOOL _isPassword = YES;
    for(int i=0;i<[password length];i++)
    {
        unichar char_password = [password characterAtIndex:i];
        if((char_password>=48 && char_password<=57) ||
           (char_password>=97 && char_password<= 122) ||
           (char_password>=65 && char_password<= 90))
        {
            // 是数字或者小写字母或者大写字母
        }
        else
        {
            _isPassword = NO;
            return _isPassword;
        }
    }
    
    return _isPassword;
}

//TODO: 判断输入是否数字 0-9 和 小数点.
+ (BOOL) isDigital:(NSString *)aString
{
    if([aString length] == 0)
        return NO;
    
    for(int i=0;i<[aString length];i++)
    {
        char aa = [aString characterAtIndex:i];
        if(!((aa>= '0' && aa<= '9') || aa=='.'))
        {
            ///有非数字
            return NO;
        }
    }
    
    return YES;
}
//TODO: 纯数字 0-9
+ (BOOL) isNumber:(NSString *)aString{
    if([aString length] == 0)
        return NO;
    
    for(int i=0;i<[aString length];i++)
    {
        char aa = [aString characterAtIndex:i];
        if(!(aa>= '0' && aa<= '9'))
        {
            ///有非数字
            return NO;
        }
    }
    
    return YES;
}

//TODO: 判断是否身份号
+(BOOL) isIDNumber:(NSString *)aString
{
    //旧身份证15位，新身份证（二代）18位
    if([aString length] != 15 && [aString length]!=18)
        return NO;
    else
    {
        //15 位时
        if([aString length] == 15)
        {
            for(int i=0;i<15;i++)
            {
                char aa = [aString characterAtIndex:i];
                if(!(aa>= '0' && aa<= '9'))
                {
                    ///有非数字
                    return NO;
                }
            }
            
            return YES;
        }
        // 18位时
        else if([aString length] == 18)
        {
            // 前17位数字，后一位可能是字母
            for(int i=0;i<17;i++)
            {
                char aa = [aString characterAtIndex:i];
                if(!(aa>= '0' && aa<= '9'))
                {
                    ///有非数字
                    return NO;
                }
            }
            // 第18位
            char aa = [aString characterAtIndex:17];
            if(!((aa>=48 && aa<=57)||(aa>=97 && aa<= 122)||(aa>=65 && aa<= 90)))
            {
                //非字母或数字，则 NO
                return NO;
            }
            
            return YES;
        }
    }
    
    return YES;
}

//TODO: 判断字符串是否6位数字
+ (BOOL) isSixDigitalPassword:(NSString *)password{
    if ([password length]!=6) {
        return NO;
    }
    
    for(int i=0;i<[password length];i++)
    {
        char aa = [password characterAtIndex:i];
        if(!(aa>= '0' && aa<= '9'))
        {
            ///有非数字
            return NO;
        }
    }
    return YES;
}
//TODO: 判断字符串是否6－16位字符（大小写字符和数字）
+ (BOOL) isSixToThTwelvePassword:(NSString *)password{
    if ([password length]<6 || [password length] >16) {
        return NO;
    }
    
    // ASCll码表: 0-9: 48-57  a-z: 97-122  A-Z; 65-90
    BOOL _isPassword = YES;
    for(int i=0;i<[password length];i++)
    {
        unichar char_password = [password characterAtIndex:i];
        if((char_password>=48 && char_password<=57) ||
           (char_password>=97 && char_password<= 122) ||
           (char_password>=65 && char_password<= 90))
        {
            // 是数字或者小写字母或者大写字母
        }
        else
        {
            _isPassword = NO;
            return _isPassword;
        }
    }
    
    return _isPassword;
}

//TODO: 是否正常银行卡号（10－32位）
+ (BOOL) isCardNumber:(NSString *)aString{
    if ([aString length]<10 || [aString length] >32) {
        return NO;
    }
    
    for(int i=0;i<[aString length];i++)
    {
        char aa = [aString characterAtIndex:i];
        if(!(aa>= '0' && aa<= '9'))
        {
            ///有非数字
            return NO;
        }
    }
    
    return YES;
}

//TODO: md5 加密方法
+ (NSString *)md5Digest:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}
//屏蔽账号:只显示前4位和后4位
+ (NSString *) screenIDWithIdStr:(NSString *)idStr{
    int lenth = [idStr length];
    NSString *newStr = [NSString string];
    if (lenth >=10) {
        NSString *xSt=@"*";
        for (int i=1; i<lenth-8; i++) {
            xSt = [NSString stringWithFormat:@"%@%@",xSt,@"*"];
        }
        
        newStr = [NSString stringWithFormat:@"%@%@%@",[idStr substringToIndex:4],xSt,[idStr substringFromIndex:lenth-4]];
    }
    
    return newStr;
}
//判断字符串是否非空（空字符串也为空）
+ (BOOL)isNotNULL:(NSString *)string{
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return [@(string.length) boolValue];
}

// 判断输入文字是否含有表情字符
+ (BOOL)isContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

//邮箱格式验证
+(BOOL)isEmailTest:(NSString *)email{
    
    
    if (![email hasSuffix:@".com"] && ![email hasSuffix:@".cn"]) {
        return NO;
    }
    NSArray *aray = [email componentsSeparatedByString:@"@"];
    if (aray.count != 2) {
        return NO;
    }
    
    return YES;
}

-(CGSize)calculateTextSizeWithFont:(UIFont *)font Size:(CGSize)size{
    return   [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}


@end
