//
//  UIViewController+style.h
//  MrMoney
//
//  Created by xingyong on 14-3-25.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MSecurityView;
@interface UIViewController (style)
 
-(void)hiddenBarView:(UIView *)toolBarView;
-(void)showBarView:(UIView *)toolBarView;

-(void)move:(UIView *)toolBarView height:(float)height;

-(MSecurityView *)securityView:(UIView *)topView;

@end
