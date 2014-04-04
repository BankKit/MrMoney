//
//  MColorView.m
//  MrMoney
//
//  Created by xingyong on 13-12-4.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MColorButton.h"
#import "Common.h"
#import "MHomeViewController.h"
#import "MAnimation.h"
@implementation MColorButton

- (id)initWithFrame:(CGRect)frame buttonTag:(NSInteger )tag
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setExclusiveTouch:YES];
        
 
        self.tag = tag;
        
        [self addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)buttonClick:(id)sender{
 
    UIButton *button = (UIButton *)sender;
  
    CAKeyframeAnimation *popAnimation = [MAnimation getKeyframeAnimation];
    
    [[self superview].layer addAnimation:popAnimation forKey:nil];
  
    if (self.delegate && [self.delegate respondsToSelector:@selector(colorButtonClick:)]) {
 
        [self.delegate colorButtonClick:button.tag];
    }
    
}
 
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
 
    /**
     *  方法 -
     */

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect paperRect = self.bounds;
 
    drawLinearGradient(context, paperRect, self.startColor.CGColor, self.endColor.CGColor);
    
    /**
     *  方法 二
     *
     */
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGGradientRef myGradient;
//    CGColorSpaceRef myColorSpace;
//    size_t locationCount = 3;
//    CGFloat locationList[] = {0.0, 0.5, 1.0};
//    
//      CGFloat colorList[] =
//        {
//           
//            0.42,0.65,0.15,1.00,
//            0.44,0.68,0.16 ,1.00,
//            0.45,0.71 ,0.18 ,1.00,
//      
//         };
//    
////    CGFloat colorList[] = {
////        201/255.0, 201/255.0, 201/255.0, 1.0,
////        43/255.0, 43/255.0, 43/255.0, 1.0
////    };
//    myColorSpace = CGColorSpaceCreateDeviceRGB();
//    
//    myGradient = CGGradientCreateWithColorComponents(myColorSpace, colorList,
//                                                     locationList, locationCount);
//    
//    CGPoint startPoint, endPoint;
//    
//    startPoint.x = 0;
//    startPoint.y = 0;
//    endPoint.x = self.frame.size.width;
//    endPoint.y = self.frame.size.height;
//    
//    CGContextDrawLinearGradient(context, myGradient, startPoint, endPoint,0); //线性梯度
    
}



@end
