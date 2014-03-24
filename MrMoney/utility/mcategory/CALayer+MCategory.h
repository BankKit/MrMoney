//
//  CALayer+MCategory.h
//  MrMoney
//
//  Created by xingyong on 13-12-5.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (MCategory)
/**
 *  设置带阴影的圆角边框
 *
 *  @param size    阴影大小
 *  @param radius  圆角角度
 *  @param opacity 透明度
 *  @param color   边框颜色
 */
-(void)shadowOffSet:(CGSize )size
       shadowRadius:(CGFloat)radius
      shadowOpacity:(CGFloat)opacity
        shadowColor:(UIColor *)color;

/**
 *  设置圆角
 *
 *  @param width  边框宽度
 *  @param color  边框颜色
 *  @param radius 边框角度
 */
-(void)borderWidth:(CGFloat)width
       borderColor:(UIColor *)color
      cornerRadius:(CGFloat )radius;


@end
