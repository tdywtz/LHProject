//
//  LHFriendsTableViewCell.m
//  LHProject
//
//  Created by luhai on 16/3/31.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "LHFriendsTableViewCell.h"

@implementation LHFriendsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = colorViewBackColor;
    }
    
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
