//
//  UIViewController+style.h
//  MrMoney
//
//  Created by xingyong on 14-3-25.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (style)

//- (void)showNavigationBar:(BOOL)animated;
//- (void)hideNavigationBar:(BOOL)animated;
//- (void)moveNavigtionBar:(CGFloat)deltaY animated:(BOOL)animated;
//- (void)setNavigationBarOriginY:(CGFloat)y animated:(BOOL)animated;

//- (void)showToolbar:(BOOL)animated;
//- (void)hideToolbar:(BOOL)animated;
//- (void)moveToolbar:(CGFloat)deltaY animated:(BOOL)animated;
//- (void)setToolbarOriginY:(CGFloat)y animated:(BOOL)animated;
//
//- (void)showTabBar:(BOOL)animated;
//- (void)hideTabBar:(BOOL)animated;
//- (void)moveTabBar:(CGFloat)deltaY animated:(BOOL)animated;
//- (void)setTabBarOriginY:(CGFloat)y animated:(BOOL)animated;


-(void)hiddenBarView:(UIView *)toolBarView;
-(void)showBarView:(UIView *)toolBarView;

-(void)move:(UIView *)toolBarView height:(float)height;

@end
