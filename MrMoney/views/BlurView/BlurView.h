//
//  BlurView.h
//  TestBlurView
//
//  Created by xingyong on 14-3-11.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^blurViewBlock)(void);

@interface BlurView : UIView

@property (nonatomic, strong) UIImageView *blurView;

@property(nonatomic, strong) UIColor *blurTintColor UI_APPEARANCE_SELECTOR;

@property(nonatomic, copy) blurViewBlock actionBlock;

- (void)show;

- (id)initWithFrame:(CGRect)frame withXib:(NSString *)xib action:(blurViewBlock )actionBlock;

//BlurView *blurView =[[BlurView alloc] initWithFrame:CGRectMake(0, 0, 250, 375) withNib:@"MPopView" action:^{
//    [MGo2PageUtility go2MFinanceProductsViewController:self pushType:MPopType];
//    
//}];

@end
