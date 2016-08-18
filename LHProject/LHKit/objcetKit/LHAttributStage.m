//
//  LHAttributStage.m
//  lhproject
//
//  Created by bangong on 16/3/23.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "LHAttributStage.h"

@implementation LHAttributStage
- (instancetype)init
{
    self = [super init];
    if (self) {
        _textColor = [UIColor blackColor];
        _textFont = [UIFont systemFontOfSize:15];
        _characterSpace = 0;
        
        _lineBreakMode = NSLineBreakByCharWrapping;
        _lineSpacing = 4;
        _alignment = NSTextAlignmentJustified;
        //_hyphenationFactor = 8;
        _firstLineHeadIndent = _textFont.pointSize*2;
        _paragraphSpacing = _textFont.pointSize;
    }
    return self;
}


@end
