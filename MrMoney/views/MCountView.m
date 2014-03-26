//
//  MCountView.m
//  MrMoney
//
//  Created by xingyong on 14-3-17.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MCountView.h"
#import "TTTAttributedLabel.h"
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
        _balanceLabel = [[TTTAttributedLabel alloc] initWithFrame:Rect(0, 0, frame.size.width, frame.size.height)];
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
            _balanceLabel.font = FONT(kHelveticaLight, 38);
//            _balanceLabel.shadowColor =[UIColor lightGrayColor];
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
 
    if (self.superview != nil) {
        [self setupUpdateTimer];
    } else {
        [self.animationTimer invalidate];
        self.animationTimer = nil;
    }
}


#pragma mark Update Timer

- (void)setupUpdateTimer;
{
    
    self.animationTimer = [NSTimer timerWithTimeInterval:1.0 target:self
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
    
    __weak MCountView *wself = self;
    if (self.balance > 0.0) {
        
        NSString *balanceStr =_flag ? STRING_FORMAT(@"￥%@",formatIntValue(totalBalance, 6)):formatIntValue(totalBalance, 6);

        
        [_balanceLabel setText:balanceStr afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString  *(NSMutableAttributedString *mutableAttributedString) {
            
            if (![balanceStr containsString:@"."]) {
                return nil;
            }
            
            NSRange range = [balanceStr rangeOfString:@"."];
            
             NSString *subString = [balanceStr substringFromIndex:range.location + 3];
            
             NSRange boldRange ={wself.flag?7:6,4};
            
            if (![subString isEqualToString:@"0000"]) {
                boldRange = [balanceStr rangeOfString:subString];
            }
 
            
            UIFont *boldSystemFont = FONT(kHelveticaLight,wself.flag ? 12: 24);
            CTFontRef font = CTFontCreateWithName((CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
            if (font) {
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
                [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:wself.flag?(id)[[UIColor whiteColor] CGColor] :(id)[[UIColor orangeColor] CGColor] range:boldRange];
                
                CFRelease(font);
            }
            
            return mutableAttributedString;
        }];
        
    }

    
}
- (void)start
{
    if (self.animationTimer == nil) {
        [self setupUpdateTimer];
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
