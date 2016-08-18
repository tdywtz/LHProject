//
//  UIImage+LH.h
//  LHProject
//
//  Created by bangong on 16/4/6.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LH)

/**改变图片尺寸*/
- (UIImage *)scaleToSize:(CGSize)size;

- (UIImage*)getSubImageWithCGRect:(CGRect)mCGRect centerBool:(BOOL)centerBool;
@end
