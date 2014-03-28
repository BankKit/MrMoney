//
//  MPayView.m
//  KDropDownMultipleSelection
//
//  Created by xingyong on 14-3-5.
//  Copyright (c) 2014年 macmini17. All rights reserved.
//

#import "MPayView.h"

@implementation MPayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [_payBtn setBackgroundImage:[[UIImage imageNamed:@"home_pay_normal"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];

    [_payBtn setBackgroundImage:[[UIImage imageNamed:@"home_pay_light"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    
    [_backImageView setImage:[[UIImage imageNamed:@"home_input"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    [_backImageView2 setImage:[[UIImage imageNamed:@"home_input"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
