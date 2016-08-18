 //
//  UIColor+LH.h
//  lhproject
//
//  Created by bangong on 16/3/23.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    ColorSchemeAnalagous = 0,
    ColorSchemeMonochromatic,
    ColorSchemeTriad,
    ColorSchemeComplementary
}ColorScheme;

@interface UIColor (LH)

// Color Methods
+(UIColor *)colorFromHex:(NSString *)hexString;
+(UIColor *)colorFromHex:(NSString *)hexString andAlpa:(CGFloat)aAlpa;
+(NSString *)hexFromColor:(UIColor *)color;
+(NSArray *)rgbaArrayFromColor:(UIColor *)color;
+(NSArray *)hsbaArrayFromColor:(UIColor *)color;

// Generate Color Scheme
+(NSArray *)generateColorSchemeFromColor:(UIColor *)color ofType:(ColorScheme)type;

@end
