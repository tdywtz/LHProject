//
//  NewsListViewController.h
//  chezhiwang
//
//  Created by bangong on 15/9/7.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsListViewController : UIViewController

@property (nonatomic,copy) NSString *urlString;
//**列表是否有头部视图*/
@property (nonatomic,assign) BOOL tableHeaderViewHave;
@end
