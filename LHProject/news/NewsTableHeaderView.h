//
//  NewsTableHeaderView.h
//  chezhiwang
//
//  Created by bangong on 16/3/22.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableHeaderView : UIView

@property (nonatomic,copy) void(^clickImage)(NSDictionary * dictionary);

@property (nonatomic,strong) NSArray *pointImages;

-(void)clickImage:(void(^)(NSDictionary * dictionary))block;
@end
