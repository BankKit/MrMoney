//
//  UIViewController+style.m
//  MrMoney
//
//  Created by xingyong on 14-3-25.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "UIViewController+style.h"
#import "MSecurityView.h"
@implementation UIViewController (style)

-(MSecurityView *)securityView:(UIView *)topView{
    
    MSecurityView *securityView = [[MSecurityView alloc] initWithFrame:Rect(10, topView.frameHeight + topView.frameY + 20, 300, 208)];
    
    securityView.backgroundColor = [UIColor whiteColor];
    
    return securityView;
    
}

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
