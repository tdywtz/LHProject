//
//  ZoonTableViewCell.m
//  LHProject
//
//  Created by bangong on 16/4/20.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "ZoonTableViewCell.h"
#import "LHChatListView.h"

@implementation ZoonTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makUI];
    }
    
    return self;
}

-(void)makUI{
    self.listView = [[LHChatListView alloc] init];
    [self.contentView addSubview:self.listView];
    [self.listView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
    
    self.listView.modelArray = @[@"",@"",@"",@"",@"",@"",@""];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
