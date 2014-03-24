//
//  UIColor+MCategory.h
//  MrMoney
//
//  Created by xingyong on 14-1-24.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (MCategory)

+ (UIColor *)fromHexString:(NSString *)hexString;
+ (UIColor *)randomColor;
- (UIColor *)colorByChangingAlphaTo:(CGFloat)alpha;
- (UIColor *)invertColor;

@end
