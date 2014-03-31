//
//  MLineView.m
//  MrMoney
//
//  Created by xingyong on 13-12-5.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MLineView.h"

@implementation MLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = KCLEAR_COLOR;
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];

    if (self) {
        
        [self  setNeedsDisplay];
    }

    return self;

}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

// 画一条虚线
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGFloat lengths[]  = {5,5};
    CGContextSetLineDash(context, 0, lengths,1);
    CGContextMoveToPoint(context, 0.0, 1.0);
    CGContextAddLineToPoint(context, self.frame.size.width,1.0);
    CGContextStrokePath(context);
 
}


@end
