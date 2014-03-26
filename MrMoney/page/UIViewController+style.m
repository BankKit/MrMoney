//
//  UIViewController+style.m
//  MrMoney
//
//  Created by xingyong on 14-3-25.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "UIViewController+style.h"

@implementation UIViewController (style)

//#pragma mark -
//#pragma mark manage ToolBar
//
//- (void)showToolbar:(BOOL)animated
//{
//    CGSize viewSize = self.navigationController.view.frame.size;
//    CGFloat viewHeight = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? viewSize.height : viewSize.width;
//    CGFloat toolbarHeight = self.navigationController.toolbar.frame.size.height;
//    [self setToolbarOriginY:viewHeight - toolbarHeight animated:animated];
//}
//
//- (void)hideToolbar:(BOOL)animated
//{
//    CGSize viewSize = self.navigationController.view.frame.size;
//    CGFloat viewHeight = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? viewSize.height : viewSize.width;
//    [self setToolbarOriginY:viewHeight animated:animated];
//}
//
//- (void)moveToolbar:(CGFloat)deltaY animated:(BOOL)animated
//{
//    CGRect frame = self.navigationController.toolbar.frame;
//    CGFloat nextY = frame.origin.y + deltaY;
//    [self setToolbarOriginY:nextY animated:animated];
//}
//
//- (void)setToolbarOriginY:(CGFloat)y animated:(BOOL)animated
//{
//    CGRect frame = self.navigationController.toolbar.frame;
//    CGFloat toolBarHeight = frame.size.height;
//    CGSize viewSize = self.navigationController.view.frame.size;
//    CGFloat viewHeight = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? viewSize.height : viewSize.width;
//    
//    CGFloat topLimit = viewHeight - toolBarHeight;
//    CGFloat bottomLimit = viewHeight;
//    
//    frame.origin.y = fmin(fmax(y, topLimit), bottomLimit); // limit over moving
//    
//    [UIView animateWithDuration:animated ? 0.1 : 0 animations:^{
//        self.navigationController.toolbar.frame = frame;
//    }];
//}
//
//#pragma mark -
//#pragma mark manage TabBar
//
//- (void)showTabBar:(BOOL)animated
//{
//    CGFloat viewHeight = self.tabBarController.view.frame.size.height;
//    CGFloat toolbarHeight = self.tabBarController.tabBar.frame.size.height;
//    [self setToolbarOriginY:viewHeight - toolbarHeight animated:animated];
//}
//
//- (void)hideTabBar:(BOOL)animated
//{
//    CGSize viewSize = self.tabBarController.view.frame.size;
//    CGFloat viewHeight = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? viewSize.height : viewSize.width;
//    [self setToolbarOriginY:viewHeight animated:animated];
//}
//
//- (void)moveTabBar:(CGFloat)deltaY animated:(BOOL)animated
//{
//    CGRect frame =  self.tabBarController.tabBar.frame;
//    CGFloat nextY = frame.origin.y + deltaY;
//    [self setToolbarOriginY:nextY animated:animated];
//}
//
//- (void)setTabBarOriginY:(CGFloat)y animated:(BOOL)animated
//{
//    CGRect frame = self.tabBarController.tabBar.frame;
//    CGFloat toolBarHeight = frame.size.height;
//    CGSize viewSize = self.tabBarController.view.frame.size;
//    CGFloat viewHeight = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? viewSize.height : viewSize.width;
//    
//    CGFloat topLimit = viewHeight - toolBarHeight;
//    CGFloat bottomLimit = viewHeight;
//    
//    frame.origin.y = fmin(fmax(y, topLimit), bottomLimit); // limit over moving
//    
//    [UIView animateWithDuration:animated ? 0.1 : 0 animations:^{
//        self.tabBarController.tabBar.frame = frame;
//    }];
//}
//

-(void)hiddenBarView:(UIView *)toolBarView{
    [UIView animateWithDuration:0.2 animations:^{
        toolBarView.frameY = self.view.bounds.size.height;
    }];
}
-(void)showBarView:(UIView *)toolBarView{
    [UIView animateWithDuration:0.2 animations:^{
        toolBarView.frameY = self.view.bounds.size.height - 49;
    }];
}

-(void)move:(UIView *)toolBarView height:(float)height{
    [UIView animateWithDuration:0.1 animations:^{
        toolBarView.frameY =  toolBarView.frameY + height;
    }];
}

 

@end
