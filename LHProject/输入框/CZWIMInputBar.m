//
//  CZWIMInputBar.m
//  autoService
//
//  Created by bangong on 16/1/4.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWIMInputBar.h"

@interface CZWIMInputBar ()<UITextViewDelegate>
{
    CGRect _startFrame;
}
@end

@implementation CZWIMInputBar
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = colorViewBackColor;
        
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin);
        self.opaque = YES;
        
        _allowsSendVoice = NO;
        _allowsSendFace = NO;
        _allowsSendMore = NO;
        self.hideKeyboardWhenSend = YES;
    
        [self constructUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}

-(void)keyboardWillShow:(NSNotification *)notification{
   
    CGFloat height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
     [self updateConstraints:^(MASConstraintMaker *make) {
         make.bottom.equalTo(-height);
     }];
}

-(void)keyboardWillHide:(NSNotification *)notification{
 
    [self updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(0);
    }];
}

- (void)updateUI{

}

- (void)constructUI{
    self.textView = [[CZWIMInputTextView alloc] initWithFrame:CGRectZero];
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
    self.textView.placeHolder = @"咨询";
    self.textView.delegate = self;
    self.textView.scrollEnabled = YES;
    self.textView.layer.cornerRadius = 5;
    self.textView.font = [UIFont systemFontOfSize:15];
    self.textView.textAlignment = NSTextAlignmentJustified;
    [self.textView.layer setCornerRadius:5.];
    [self.textView.layer setBorderWidth:0.5];
    [self.textView.layer setShadowOffset:CGSizeMake(0, 0)];
    [self.textView.layer setShadowRadius:4.];
    [self.textView.layer setShadowColor:[UIColor whiteColor].CGColor];
    [self.textView.layer setBorderColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1].CGColor];
    [self addSubview:self.textView];
    
    [self.textView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(5);
        make.right.equalTo(-5);
        make.top.equalTo(5);
        make.height.equalTo(self.textView.font.pointSize+self.textView.font.lineHeight);
       // make.bottom.equalTo(-5);
    }];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"tupian" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.bottom).offset(5);
        make.left.equalTo(10);
        make.bottom.equalTo(-5);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChange:) name:UITextViewTextDidChangeNotification object:nil];
}

-(void)textViewChange:(NSNotification *)notification{
    [self.textView layoutIfNeeded];
    CGFloat height = [self.textView.text calculateTextSizeWithFont:self.textView.font Size:CGSizeMake(self.textView.frame.size.width, 200)].height;
   
    if (height < self.textView.font.lineHeight+self.textView.font.pointSize) {
        [self.textView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.textView.font.lineHeight+self.textView.font.pointSize);
        }];
    }else if (height < self.textView.font.lineHeight*5){
        [self.textView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }else{
        [self.textView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.textView.font.lineHeight*4);
        }];
    }
}

-(void)buttonClick{
    if ([self.delegate respondsToSelector:@selector(selectedButton:)]) {
        [self.delegate selectedButton:0];
    }
}

+ (CGFloat)maxLines {
    
    return 4;
}

- (CGFloat)boradHeight
{
    if (!self.expand) return 0.;
    if (self.type == CZWIMInputBarTypeText)return self.keyboradHeight;
    return 226.f;
}


#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    //[self.delegate CZWIMInputBarTextViewWillBeginEditing:self.textView];
//    
//    self.faceBtn.selected = NO;
//    self.moreBtn.selected = NO;
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [textView becomeFirstResponder];
  //  [self.delegate actIMInputBarTextViewDidBeginEditing:self.textView];
    
    self.expand = YES;
    self.type = CZWIMInputBarTypeText;
}


- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
  
   // [self.delegate CZWIMInputBarTextViewDidEndEditing:self.textView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"])
    {
       
        [self.delegate CZWIMInputBarDidSendTextAction:textView.text];
        if (self.hideKeyboardWhenSend)
        {
//            [_textView resignFirstResponder];
            self.expand = NO;
        }
        return NO;
    }
    
    if ([text isEqualToString:@""] && range.length > 0)
    {
//        NSString* text = [[CZWIMEmotionManager shared] handleDel:self.textView.text range:range];
//        if (!text)
//        {
//            return YES;
//        }
//        else
//        {
//            textView.text = text;
//            return NO;
//        }
    }
    
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
