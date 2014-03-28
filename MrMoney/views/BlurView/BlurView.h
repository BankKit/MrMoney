//
//  BlurView.h
//  TestBlurView
//
//  Created by xingyong on 14-3-11.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MFinanceProductData;

typedef void(^blurViewBlock)(void);

typedef MFinanceProductData* (^orderDataBlock)(void);


@interface BlurView : UIView

@property (nonatomic, strong) UIImageView *blurView;

@property(nonatomic, strong) UIColor *blurTintColor UI_APPEARANCE_SELECTOR;

@property(nonatomic, copy) blurViewBlock actionBlock;

@property(nonatomic, strong) UIControl *overlayView;

@property(nonatomic, strong) NSString *xib;

- (void)show;

- (id)initWithFrame:(CGRect)frame withXib:(NSString *)xib action:(blurViewBlock )actionBlock;

- (id)initWithFrame:(CGRect)frame withXib:(NSString *)xib action:(blurViewBlock )actionBlock orderData:(MFinanceProductData *)data amount:(int )amount payStyle:(NSString *)pay;
 

 

@end
