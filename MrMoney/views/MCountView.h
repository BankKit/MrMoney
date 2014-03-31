//
//  MCountView.h
//  MrMoney
//
//  Created by xingyong on 14-3-17.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLabel;

@interface MCountView : UIView
@property (nonatomic, strong) NSTimer *animationTimer;

@property (nonatomic,assign) double balance;

@property (nonatomic,assign) float todayIncome;

@property (nonatomic,assign) MHomeViewControllerPushType type;

@property (nonatomic,assign) BOOL flag;

@property (nonatomic,strong)MLabel *balanceLabel;

- (id)initWithFrame:(CGRect)frame
            balance:(double )balance
        todayIncome:(float)todayIncome
           type:(MHomeViewControllerPushType )type;

 

- (void)start;

- (void)stop;

@end
