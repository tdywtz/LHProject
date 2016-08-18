//
//  LHUserInfo.h
//  chat
//
//  Created by luhai on 16/1/9.
//  Copyright © 2016年 luhai. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;

@interface LHUserInfo : NSObject

@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *nikeName;
@property (nonatomic,copy) NSString *iconImageUrl;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,copy) NSString *subscription;

@end
