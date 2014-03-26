//
//  MGradientView.h
//  MrMoney
//
//  Created by xingyong on 14-3-25.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>
 
typedef enum : NSUInteger {
    topToBottom = 0,//从上到下
    leftToRight = 1,//从左到右
    upleftTolowRight = 2,//左上到右下
    uprightTolowLeft = 3,//右上到左下
    
}GradientType;

 
@interface MGradientView : UIView
- (id)initWithFrame:(CGRect)frame FromColorArray:(NSArray*)colorArray ByGradientType:(GradientType)gradientType;

@end
