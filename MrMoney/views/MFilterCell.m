//
//  MFilterCell.m
//  MrMoney
//
//  Created by xingyong on 14-1-21.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MFilterCell.h"

@implementation MFilterCell

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
    if (self.groupId == nil) {
        self.groupId = @"section1";
    }
 
 
 
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
