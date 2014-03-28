//
//  MAnimation.h
//  MrMoney
//
//  Created by xingyong on 14-3-27.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAnimation : NSObject

+ (CABasicAnimation *)showAnimation:(NSInteger)animationDuration;
+ (CABasicAnimation *)hideAnimation:(NSInteger)animationDuration;
+ (CABasicAnimation *)rotationAnimation;
+ (CABasicAnimation *)shakeAnimation;
+ (CAKeyframeAnimation *)getKeyframeAnimation;
    
@end
