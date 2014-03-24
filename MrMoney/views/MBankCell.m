//
//  MBankCell.m
//  MrMoney
//
//  Created by xingyong on 14-1-8.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBankCell.h"

@implementation MBankCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (IsIOS7) {
        self.contentView.frameX = 10;
    }
}
 
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
