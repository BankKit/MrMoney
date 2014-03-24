//
//  MSegmentView.m
//  MrMoney
//
//  Created by xingyong on 14-1-6.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MSegmentView.h"

@implementation MSegmentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    NSArray *titleArray = @[@"收益率",@"期限",@"进度",@"筛选"];
    if (self) {
        // Initialization code
        sliderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
        sliderView.backgroundColor = [UIColor colorWithRed:0.20 green:0.21 blue:0.23 alpha:1.00];
        [self addSubview:sliderView];
        
         self.backgroundColor = [UIColor colorWithRed:0.15 green:0.16 blue:0.17 alpha:1.00];
        
        for (int i = 0 ; i< 4; i ++) {
           
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(((i+1) * 80) - 40  - 10   , 10, 20, 20);
            NSString *image_normal = [NSString stringWithFormat:@"btn_segment_normal%d",i+1];
            NSString *image_selected = [NSString stringWithFormat:@"btn_segment_selected%d",i+1];
          
            [button setImage:[UIImage imageNamed:image_normal] forState:UIControlStateNormal];
            
            button.tag = i + 1 ;
            [button setImage:[UIImage imageNamed:image_selected] forState:UIControlStateSelected];
            
            [button addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(((i+1) * 80) - 40 -20   , 28, 40, 21)];
            titleLabel.tag = i + 1 + 100;
            titleLabel.backgroundColor = KCLEAR_COLOR;
            titleLabel.textColor = [UIColor lightGrayColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = BOLDFONT(12);
            titleLabel.text = [titleArray objectAtIndex:i];
            [self addSubview:titleLabel];
            
            
            if (i == 1) {
                [self segmentAction:button];
            }
            
            [self addSubview:button];
           
        }
        
     

    }
    return self;
}
 
-(void)segmentAction:(UIButton *)btn{
    //切换button状态的操作
    
    if (btn.tag != 4) {
       sliderView.frame = CGRectMake((btn.tag - 1) * 80 + 0.8, 0, 79 , 50);
        UILabel *titleLabel = (UILabel *)[self viewWithTag:btn.tag + 100];
        
        titleLabel.textColor = [UIColor whiteColor];
        
        _currentBtn.selected = NO;
        btn.selected = YES;
        _currentBtn = btn;
       
        _currentLabel.textColor = [UIColor lightGrayColor];
        _currentLabel = titleLabel;
        
    }
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(segmentView:didSelectedSegmentAtIndex:)]) {
        [self.delegate segmentView:self didSelectedSegmentAtIndex:btn.tag];
    }

}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    
    self.clipsToBounds = NO;
//    if (self.drawSeparators) {
    
        CGFloat darkLineWidth = 0.5f;
        CGFloat lightLineWidth = 0.5f;
        
        UIColor *darkLineColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
        UIColor *lightLineColor = [UIColor colorWithWhite:0.5 alpha:0.4f];
        
        [self draWLineFromPoint:CGPointMake(0, darkLineWidth/2)
                        toPoint:CGPointMake(self.bounds.size.width, darkLineWidth/2)
                      withColor:darkLineColor
                          width:darkLineWidth];
        
        [self draWLineFromPoint:CGPointMake(0, darkLineWidth + lightLineWidth/2)
                        toPoint:CGPointMake(self.bounds.size.width, darkLineWidth + lightLineWidth/2)
                      withColor:lightLineColor
                          width:lightLineWidth];
        
//        [self draWLineFromPoint:CGPointMake(0, self.bounds.size.height - darkLineWidth/2 - lightLineWidth)
//                        toPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height - darkLineWidth/2 - lightLineWidth)
//                      withColor:darkLineColor
//                          width:darkLineWidth];
//        
//        [self draWLineFromPoint:CGPointMake(0, self.bounds.size.height - lightLineWidth/2)
//                        toPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height - lightLineWidth/2)
//                      withColor:lightLineColor
//                          width:lightLineWidth];
    
    
        [self draWLineFromPoint:CGPointMake(80+ darkLineWidth  , 0)
                        toPoint:CGPointMake(80 + darkLineWidth  , 50)
                      withColor:lightLineColor
                          width:lightLineWidth];
    
    [self draWLineFromPoint:CGPointMake(80+ darkLineWidth + lightLineWidth/2, 0)
                    toPoint:CGPointMake(80+ darkLineWidth + lightLineWidth/2, 50)
                  withColor:lightLineColor
                      width:lightLineWidth];
    
    
        [self draWLineFromPoint:CGPointMake(160+ darkLineWidth, 0)
                        toPoint:CGPointMake(160+ darkLineWidth, 50+darkLineWidth)
                      withColor:lightLineColor
                          width:lightLineWidth];
    
    [self draWLineFromPoint:CGPointMake(160+ darkLineWidth + lightLineWidth/2, 0)
                    toPoint:CGPointMake(160+ darkLineWidth + lightLineWidth/2, 50)
                  withColor:lightLineColor
                      width:lightLineWidth];
    
        [self draWLineFromPoint:CGPointMake(240+ darkLineWidth, 0)
                        toPoint:CGPointMake(240+ darkLineWidth, 50+darkLineWidth)
                      withColor:lightLineColor
                          width:lightLineWidth];
    
    [self draWLineFromPoint:CGPointMake(240+ darkLineWidth + lightLineWidth/2, 0)
                    toPoint:CGPointMake(240+ darkLineWidth + lightLineWidth/2, 50)
                  withColor:lightLineColor
                      width:lightLineWidth];
    
//    }
}

- (void)draWLineFromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo withColor:(UIColor *)color width:(CGFloat)width {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, width);
    CGContextMoveToPoint(context, pointFrom.x, pointFrom.y);
    CGContextAddLineToPoint(context, pointTo.x, pointTo.y);
    CGContextStrokePath(context);
}



@end
