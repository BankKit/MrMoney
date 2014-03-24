//
//  UINavigationBar+MCategory.h
//  MrMoney
//
//  Created by xingyong on 13-12-3.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (MCategory)

- (void)useCustomNavBar:(BOOL)yesOrNo;
- (CGSize)customSizeThatFits:(CGSize)size;
- (void)setDefaultBackground;
- (void)setBackground:(UIImage*)image;
- (void)resetBackground;
- (CGFloat)getFitHeight;
- (UIImageView *)testAndGetBgView;;
- (BOOL)isUsedCustomerBg;


- (void)setNavBackground:(UIImage *)img;
@end
