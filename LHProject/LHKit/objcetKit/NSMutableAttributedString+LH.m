//
//  NSMutableAttributedString+LH.m
//  lhproject
//
//  Created by bangong on 16/3/23.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "NSMutableAttributedString+LH.h"
#import "LHAttributStage.h"

@implementation NSMutableAttributedString (LH)

-(NSMutableAttributedString *)insertImage:(UIImage *)image size:(CGSize)size into:(NSInteger)index{
    NSTextAttachment *chment = [[NSTextAttachment alloc] init];
    chment.image = image;
    chment.bounds = CGRectMake(0, 0, size.width, size.height);
    NSAttributedString *att = [NSAttributedString attributedStringWithAttachment:chment];
    
    [self insertAttributedString:att atIndex:index];
    return self;

}

+(NSMutableAttributedString *)attributedStringWithStage:(LHAttributStage *)stage string:(NSString *)string{
    if (!string) {
        return [NSMutableAttributedString new];
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = NSMakeRange(0, attributedString.length);
    //字体颜色
    [attributedString addAttribute:NSForegroundColorAttributeName value:stage.textColor range:range];
    //字体
    [attributedString addAttribute:NSFontAttributeName value:stage.textFont range:range];
    //下滑先样式
    [attributedString addAttribute:NSUnderlineStyleAttributeName value:@(stage.UnderlineStyle) range:range];
    //字距
    [attributedString addAttribute:NSKernAttributeName value:@(stage.characterSpace) range:range];
    
    //段落样式
    NSMutableParagraphStyle *parag = [[NSMutableParagraphStyle alloc] init];
    
    parag.lineSpacing = stage.lineSpacing;
    parag.paragraphSpacing = stage.paragraphSpacing;
    parag.alignment = stage.alignment;
    parag.firstLineHeadIndent = stage.firstLineHeadIndent;
    parag.headIndent = stage.headIndent;
    parag.tailIndent = stage.tailIndent;
    parag.lineBreakMode = stage.lineBreakMode;
    parag.minimumLineHeight = stage.minimumLineHeight;
    parag.maximumLineHeight = stage.maximumLineHeight;
    parag.baseWritingDirection = stage.baseWritingDirection;
    parag.lineHeightMultiple = stage.lineHeightMultiple;
    parag.paragraphSpacingBefore = stage.paragraphSpacingBefore;
    parag.hyphenationFactor = stage.hyphenationFactor;
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:parag range:range];
    // [NSAttributedString attributedStringWithAttachment:<#(nonnull NSTextAttachment *)#>]
    return attributedString;
}

@end
