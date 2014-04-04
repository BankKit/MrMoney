//
//  MImageView.m
//  MrMoney
//
//  Created by xingyong on 14-4-3.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MImageView.h"

@implementation MImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setImage:[[UIImage imageNamed:@"home_input"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
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
