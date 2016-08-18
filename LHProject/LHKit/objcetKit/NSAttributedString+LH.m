//
//  NSAttributedString+LH.m
//  lhproject
//
//  Created by bangong on 16/3/23.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "NSAttributedString+LH.h"

@implementation NSAttributedString (LH)
//**计算属性化字符串size*/
-(CGSize)calculateAttributedStringWithSize:(CGSize)size{
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
}
@end
