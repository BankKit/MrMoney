//
//  MFieldCell.m
//  MrMoney
//
//  Created by xingyong on 14-1-8.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MFieldCell.h"

@implementation MFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)amountChanged:(UITextField *)sender
{
    NSString *temp = sender.text;
   
    if (temp.length > 8) {
        sender.text = [temp substringToIndex:8];
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(amountChangedValue:)]) {
        
        [self.delegate amountChangedValue:sender.text];
    }
  
}

-(void)layoutSubviews{
    [super layoutSubviews];
     
    
    if (IsIOS7) {
        self.contentView.frameX = self.contentView.frameX + 10;

    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
