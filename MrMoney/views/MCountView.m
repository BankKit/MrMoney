//
//  MCountView.m
//  MrMoney
//
//  Created by xingyong on 14-3-17.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MCountView.h"
//#import "TTTAttributedLabel.h"
#import "MLabel.h"
@implementation MCountView

- (id)initWithFrame:(CGRect)frame
            balance:(double )balance
        todayIncome:(float)todayIncome
               type:(MHomeViewControllerPushType )type
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.balance = balance;
        self.todayIncome = todayIncome;
        _balanceLabel = [[MLabel  alloc] initWithFrame:Rect(0, 0, frame.size.width, frame.size.height)];
        self.type = type;
        
        self.flag = self.type == MHomeType ? YES : NO;
        self.userInteractionEnabled = NO;
        
        _balanceLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _balanceLabel.backgroundColor = KCLEAR_COLOR;
        _balanceLabel.numberOfLines = 0;
        if (self.flag) {
            _balanceLabel.textAlignment = NSTextAlignmentCenter;
            _balanceLabel.textColor = [UIColor whiteColor];
            _balanceLabel.font = FONT(kHelveticaLight, 18);
        }else{
            _balanceLabel.font = FONT(kHelveticaLight, 36);
            
            _balanceLabel.textColor =  [UIColor orangeColor];
        }
        
        [self addSubview:_balanceLabel];
        
        [self updateValuesAnimated:YES];
        
    }
    return self;
}

#pragma mark UIView

- (void)didMoveToSuperview;
{
    
    if (_todayIncome > 0.0) {
        if (self.superview != nil) {
            [self setupUpdateTimer];
        } else {
            [self.animationTimer invalidate];
            self.animationTimer = nil;
        }
        
    }
}


#pragma mark Update Timer

- (void)setupUpdateTimer;
{
    
    self.animationTimer = [NSTimer timerWithTimeInterval:3.0 target:self
                                                selector:@selector(handleTimer:)
                                                userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.animationTimer forMode:NSRunLoopCommonModes];
    
    
}

- (void)handleTimer:(NSTimer*)timer;
{
    [self updateValuesAnimated:YES];
}

- (void)updateValuesAnimated:(BOOL)animated;
{
    double currentSceond =  ([MUtility getSecond] * _todayIncome);
    
    double totalBalance   = _balance +  currentSceond;
    
    NSString *l_str =  formatIntValue(totalBalance, 6);
    
    NSString *balanceStr = self.flag ? STRING_FORMAT(@"￥%@",l_str) : l_str;
    
    if ([balanceStr length] > 4) {
        NSRange boldRange ={[balanceStr length] - 4,4};
        
        UIFont *boldSystemFont = FONT(kHelveticaLight,self.flag ? 12: 22);
        
        _balanceLabel.text = balanceStr;
        
        [_balanceLabel setFont:boldSystemFont range:boldRange];
    }
    
}
- (void)start
{
    if (self.animationTimer == nil) {
        if (_todayIncome > 0.0) {
            [self setupUpdateTimer];
        }
        
    }
}

- (void)stop
{
    [self.animationTimer invalidate];
    self.animationTimer = nil;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
