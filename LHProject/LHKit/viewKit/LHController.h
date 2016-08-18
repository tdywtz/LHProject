//
//  LHController.h
//  auto
//
//  Created by bangong on 15/7/3.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LHController : NSObject


/**创建Label*/
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(CGFloat)font Bold:(BOOL)bold TextColor:(UIColor *)color Text:(NSString*)text;

@end
