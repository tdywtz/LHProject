//
//  LHChatListView.m
//  LHProject
//
//  Created by bangong on 16/4/20.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "LHChatListView.h"

@implementation LHChatListView


-(void)setModelArray:(NSArray *)modelArray{
    _modelArray = modelArray;
    [self createUI];
}

-(void)createUI{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
   
    UILabel *tempView = nil;
    for (int i = 0; i < self.modelArray.count; i ++) {
        UILabel *label = [[UILabel alloc] init];
      //  label.backgroundColor = [UIColor redColor];
        label.numberOfLines = 0;
        NSString *text = @"就爱上了国家队里看过的考虑给家\n里的几个地方了科技管理的考试结果对方就过了多少块就够了 ";
        int k = arc4random()%text.length;
        if (k < 1) k = 1;
        text = [text substringToIndex:k];

        label.attributedText = [[NSAttributedString alloc] initWithString:text];
        [self addSubview:label];
        if (!tempView) {
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.left.and.right.equalTo(0);
            }];
        }else{
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(tempView.bottom).offset(10);
                make.left.and.right.equalTo(0);
            }];
        }
        
        tempView = label;
    }
    if (tempView) {
        [tempView updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(0);
        }];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
