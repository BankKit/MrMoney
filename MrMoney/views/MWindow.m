//
//  MWindow.m
//  MrMoney
//
//  Created by xingyong on 14-3-4.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MWindow.h"

@implementation MWindow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	if(event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake)
	{
 
		[[NSNotificationCenter defaultCenter] postNotificationName:@"shake" object:self];
	}
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}
@end
