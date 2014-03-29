//
//  MSecurityView.m
//  MrMoney
//
//  Created by xingyong on 14-2-15.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MSecurityView.h"

@implementation MSecurityView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
  
        NSArray *nibViews=[[NSBundle mainBundle] loadNibNamed:@"MSecurityView" owner:self options:nil]; //通过这个方法,取得我们的视图
        self = [nibViews objectAtIndex:0];
        self.frame=frame; //设置frame
        [self.layer borderWidth:1. borderColor:KVIEW_BORDER_COLOR cornerRadius:6.];

    }
    return self;
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
