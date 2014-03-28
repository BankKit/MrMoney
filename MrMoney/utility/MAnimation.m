//
//  MAnimation.m
//  MrMoney
//
//  Created by xingyong on 14-3-27.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MAnimation.h"

@implementation MAnimation

/**
 *  显示动画
 *
 *  @param animationDuration 动画时间
 *
 *  @return 动画显示
 */
+ (CABasicAnimation *)showAnimation:(NSInteger)animationDuration
{
    //Show the progress layer and percentage
    CABasicAnimation *showAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    showAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    showAnimation.toValue = [NSNumber numberWithFloat:1.0];
    showAnimation.duration = animationDuration;
    showAnimation.repeatCount = 1.0;
    //Prevent the animation from resetting
    showAnimation.fillMode = kCAFillModeForwards;
    showAnimation.removedOnCompletion = NO;
    return showAnimation;
}

/**
 *  隐藏动画
 *
 *  @param animationDuration 动画时间
 *
 *  @return 动画隐藏
 */
+ (CABasicAnimation *)hideAnimation:(NSInteger)animationDuration
{
    //Hide the progress layer and percentage
    CABasicAnimation *hideAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    hideAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    hideAnimation.toValue = [NSNumber numberWithFloat:0.0];
    hideAnimation.duration = animationDuration;
    hideAnimation.repeatCount = 1.0;
    //Prevent the animation from resetting
    hideAnimation.fillMode = kCAFillModeForwards;
    hideAnimation.removedOnCompletion = NO;
    return hideAnimation;
}

/**
 *  旋转动画
 *
 *  @return 动画旋转
 */
+ (CABasicAnimation *)rotationAnimation{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    
    return rotationAnimation;
}
/**
 *  抖动动画
 *
 *  @return 动画抖动
 */
+ (CABasicAnimation *)shakeAnimation{
    CABasicAnimation* shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //设置抖动幅度
    shakeAnimation.fromValue = [NSNumber numberWithFloat:-0.2];
    
    shakeAnimation.toValue = [NSNumber numberWithFloat:+0.6];
    
    shakeAnimation.duration = 0.1;
    
    shakeAnimation.autoreverses = YES; //是否重复
    
    shakeAnimation.repeatCount = 4;
    
    return shakeAnimation;
}
/**
 *  弹出框动画
 *
 *  @return 动画
 */
+ (CAKeyframeAnimation *)getKeyframeAnimation{
    CAKeyframeAnimation* popAni=[CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAni.duration = 0.5;
    
    popAni.values=@[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.0)],
                    [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)],
                    [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.0)],
                    [NSValue valueWithCATransform3D:CATransform3DIdentity]
                    ];
    
    popAni.keyTimes=@[@0.0,@0.5,@0.75,@1.0];
    
    popAni.timingFunctions=@[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    return popAni;
}

@end
