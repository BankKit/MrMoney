//
//  MRechargeCell.m
//  MrMoney
//
//  Created by xingyong on 14-3-6.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MRechargeCell.h"

@implementation MRechargeCell

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
//    self.field.background = [[UIImage imageNamed:@"home_input"] stretchableImageWithLeftCapWidth:10. topCapHeight:10.];
}

- (IBAction)textFieldDidChange:(UITextField *)textField
{
    NSString *temp = textField.text;
    
    if (temp.length > 8) {
        textField.text = [temp substringToIndex:8];
    }
    //    _countLabel.text = [NSString stringWithFormat:@"%d",m_int_limitFontNum - self.textView.text.length];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
