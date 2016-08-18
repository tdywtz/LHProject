//
//  ActIMInputTextView.m
//  ArtBox
//
//  Created by zhaoguogang on 10/31/14.
//  Copyright (c) 2014 zhaoguogang. All rights reserved.
//

#import "CZWIMInputTextView.h"

@implementation CZWIMInputTextView

#pragma mark - Setters

- (void)setPlaceHolder:(NSString *)placeHolder {
    if([placeHolder isEqualToString:_placeHolder]) {
        return;
    }
    _placeHolder = placeHolder;
    [self setNeedsDisplay];
}

- (void)setPlaceHolderTextColor:(UIColor *)placeHolderTextColor {
    if([placeHolderTextColor isEqual:_placeHolderTextColor]) {
        return;
    }
    
    _placeHolderTextColor = placeHolderTextColor;
    [self setNeedsDisplay];
}

#pragma mark - Text view overrides

- (void)setText:(NSString *)text {
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    [super setContentInset:contentInset];
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    [self setNeedsDisplay];
}

#pragma mark - Notifications

- (void)didReceiveTextDidChangeNotification:(NSNotification *)notification {
    [self setNeedsDisplay];
}

#pragma mark - Life cycle

- (void)setup {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveTextDidChangeNotification:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
    
    _placeHolderTextColor = [UIColor lightGrayColor];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.scrollIndicatorInsets = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 8.0f);
    self.contentInset = UIEdgeInsetsZero;
    self.scrollEnabled = YES;
    self.scrollsToTop = NO;
    self.userInteractionEnabled = YES;
    self.font = [UIFont systemFontOfSize:16.0f];
    self.textColor = [UIColor blackColor];
    self.backgroundColor = [UIColor whiteColor];
    self.keyboardAppearance = UIKeyboardAppearanceDefault;
    self.keyboardType = UIKeyboardTypeDefault;
    self.returnKeyType = UIReturnKeyDefault;
    self.textAlignment = NSTextAlignmentLeft;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)dealloc {
    _placeHolder = nil;
    _placeHolderTextColor = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if([self.text length] == 0 && self.placeHolder) {
       // CGFloat height = self.font.si
        CGRect placeHolderRect = CGRectMake(7.0f,
                                            8.0f,
                                            rect.size.width,
                                            rect.size.height);
        
        [self.placeHolderTextColor set];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = self.textAlignment;
        
        [self.placeHolder drawInRect:placeHolderRect
                      withAttributes:@{ NSFontAttributeName : self.font,
                                        NSForegroundColorAttributeName : self.placeHolderTextColor,
                                        NSParagraphStyleAttributeName : paragraphStyle }];

    }
}

@end

@implementation NSString (ActIMInputTextView)

- (NSString *)stringByTrimingWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
