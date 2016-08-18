//
//  TestObject.h
//  LHProject
//
//  Created by luhai on 16/4/23.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "LHObject.h"

@interface TestObject : LHObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,assign) BOOL cellOpen;
@end
