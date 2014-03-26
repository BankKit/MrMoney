//
//  MColorView.m
//  MrMoney
//
//  Created by xingyong on 13-12-4.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MColorView.h"
#import "Common.h"
#import "MHomeViewController.h"
@implementation MColorView

- (id)initWithFrame:(CGRect)frame buttonTag:(NSInteger )tag
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setExclusiveTouch:YES];
        
        UIButton *colorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        colorBtn.frame = frame;
        colorBtn.tag = tag;
        [self addSubview:colorBtn];
        
        [colorBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
+ (CAKeyframeAnimation *)getKeyframeAni{
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

-(void)buttonClick:(id)sender{
 
    UIButton *button = (UIButton *)sender;
    button.userInteractionEnabled = NO;
    
    CAKeyframeAnimation *popAnimation = [[self class] getKeyframeAni];
    
    [[self superview].layer addAnimation:popAnimation forKey:nil];
  
    if (self.delegate && [self.delegate respondsToSelector:@selector(colorViewClick:)]) {
        button.userInteractionEnabled = YES;
        
        [self.delegate colorViewClick:button.tag];
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
