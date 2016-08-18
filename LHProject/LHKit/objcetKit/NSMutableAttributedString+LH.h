//
//  NSMutableAttributedString+LH.h
//  lhproject
//
//  Created by bangong on 16/3/23.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LHAttributStage;

@interface NSMutableAttributedString (LH)

//**插入图片*/
-(NSMutableAttributedString *)insertImage:(UIImage *)image size:(CGSize)size into:(NSInteger)index;

//
+(NSMutableAttributedString *)attributedStringWithStage:(LHAttributStage *)stage string:(NSString *)string;
@end
