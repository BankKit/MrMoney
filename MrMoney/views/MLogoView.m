//
//  MLogoView.m
//  MrMoney
//
//  Created by xingyong on 14-3-24.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MLogoView.h"

@implementation MLogoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:Rect(0, 0,frame.size.height, frame.size.height)];
        imageView.center = self.center;
        imageView.image = [UIImage imageNamed:@"logoViewBg"];
        [self addSubview:imageView];
   
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
