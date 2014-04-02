//
//  DropDownViewCell.m
//  KDropDownMultipleSelection
//
//  Created by macmini17 on 03/01/14.
//  Copyright (c) 2014 macmini17. All rights reserved.
//

#import "MDropDownViewCell.h"

@implementation MDropDownViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
 
        self.detailTextLabel.textColor = [UIColor darkGrayColor];
        self.textLabel.font = SYSTEMFONT(14);
        self.detailTextLabel.font = SYSTEMFONT(12);
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frameHeight = 12.;
    self.imageView.frameWidth = 12.;
    self.imageView.frame = CGRectOffset(self.imageView.frame, 12, 6);

    self.textLabel.frame = CGRectOffset(self.textLabel.frame, 6, 0);
    self.detailTextLabel.frame = CGRectOffset(self.detailTextLabel.frame,6, 2);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
