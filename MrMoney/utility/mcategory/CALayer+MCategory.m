//
//  CALayer+MCategory.m
//  MrMoney
//
//  Created by xingyong on 13-12-5.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "CALayer+MCategory.h"

@implementation CALayer (MCategory)
-(void)shadowOffSet:(CGSize )size
       shadowRadius:(CGFloat)radius
      shadowOpacity:(CGFloat)opacity
        shadowColor:(UIColor *)color{
    
    [self setShadowOffset:size];                // 阴影的范围
    [self setShadowRadius:radius];                // 阴影扩散的范围控制
    [self setShadowOpacity:opacity];               // 阴影透明度
    [self setShadowColor:color.CGColor];
}
-(void)borderWidth:(CGFloat)width
       borderColor:(UIColor *)color
      cornerRadius:(CGFloat )radius{
    
    [self setBorderWidth:width];//画线的宽度
    [self setBorderColor:color.CGColor];//颜色
    [self setCornerRadius:radius];//圆角
    [self setMasksToBounds:YES];
}
@end
