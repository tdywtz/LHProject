//
//  LHAsset.h
//  lhproject
//
//  Created by bangong on 16/3/29.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
@interface LHAsset : NSObject

@property (nonatomic,strong) PHAsset *asset;
@property (nonatomic,strong) UIImage *iamge;
@property (nonatomic,assign) BOOL assetSelected;

@end
