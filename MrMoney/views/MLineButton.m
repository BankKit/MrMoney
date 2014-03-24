//
//  MLineButton.m
//  MrMoney
//
//  Created by xingyong on 13-12-6.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MLineButton.h"

@implementation MLineButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setNeedsDisplay];
    }
    return self;
}
-(void)setHighlighted:(BOOL)highlighted{
    
}
 
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGSize fontSize ;
    if (IsIOS7) {
        fontSize  = [self.titleLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size;
    }else {
        fontSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    }
    
 
    
    // Get the fonts color.
    
    const float * colors = CGColorGetComponents(self.titleLabel.textColor.CGColor);
    // Sets the color to draw the line
    CGContextSetRGBStrokeColor(ctx, colors[0], colors[1], colors[2], 1.0f); // Format : RGBA
    
    // Line Width : make thinner or bigger if you want
    CGContextSetLineWidth(ctx, 0.6f);
    
    // Calculate the starting point (left) and target (right)
    CGPoint l = CGPointMake(0, self.frame.size.height/2.0 + fontSize.height/2.0);
    
    CGPoint r = CGPointMake(fontSize.width,
                            self.frame.size.height/2.0 + fontSize.height/2.0);
    
    
    // Add Move Command to point the draw cursor to the starting point
    CGContextMoveToPoint(ctx, l.x, l.y);
    
    // Add Command to draw a Line
    CGContextAddLineToPoint(ctx, r.x, r.y);
    
    
    // Actually draw the line.
    CGContextStrokePath(ctx);
    
    [super drawRect:rect];

}
 

@end
