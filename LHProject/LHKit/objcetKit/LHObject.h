//
//  LHObject.h
//  LHProject
//
//  Created by luhai on 16/4/23.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHObject : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)getDictionary;
- (NSArray *)getAllProperties;
@end
