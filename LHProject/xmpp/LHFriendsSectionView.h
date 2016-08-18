//
//  LHFriendsSectionView.h
//  LHProject
//
//  Created by luhai on 16/3/31.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LHFriendsSectionViewDelegate <NSObject>

-(void)clickSectionView;

@end

@interface LHFriendsSectionView : UIView

@property (nonatomic,weak) id<LHFriendsSectionViewDelegate> delegate;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *numberLabel;
@property (nonatomic,assign) BOOL open;

@end
