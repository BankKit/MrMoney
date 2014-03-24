//
//  MTextField.m
//  MrMoney
//
//  Created by xingyong on 14-3-17.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MTextField.h"

@implementation MTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



-(CGRect)textRectForBounds:(CGRect)bounds

{
    
    return CGRectInset(bounds, 5, 0);
    
}

-(CGRect)editingRectForBounds:(CGRect)bounds

{
    
    return CGRectInset(bounds,5,0);
    
}

-(void)drawRect:(CGRect)rect
 
{
  
    UIImage *backgroundImage = [[UIImage imageNamed:@"home_input"] stretchableImageWithLeftCapWidth:10. topCapHeight:10.];
//    UIImage * backgroundImage = [[UIImage imageNamed:@"home_input"] resizableImageWithCapInsets:UIEdgeInsetsMake(15.0, 5.0, 15.0, 5.0)];
    
    [backgroundImage drawInRect:[self bounds]];
    
}




@end
