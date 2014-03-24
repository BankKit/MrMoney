//
//  MAgreementView.m
//  MrMoney
//
//  Created by xingyong on 14-1-20.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MAgreementView.h"
#import "UIView+MCategory.h"
@implementation MAgreementView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self  setNeedsDisplay];
//        [self setNeedsLayout]
    }
    
    return self;
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkBtn.frame = Rect(0,self.frameHeight/2-15, 30, 30);
    [checkBtn setImage:[UIImage imageNamed:@"btn_check_deep"] forState:UIControlStateSelected];
    [checkBtn setImage:[UIImage imageNamed:@"btn_uncheck"] forState:UIControlStateNormal];
    checkBtn.selected = YES;
    checkBtn.tag = 1;
    self.isFlag = YES;
    [checkBtn addTarget:self action:@selector(checkClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:checkBtn];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:Rect(35, 0, 100, self.frameHeight)];
    label.text = @"已阅读并同意";
    label.backgroundColor = KCLEAR_COLOR;
    label.font = SYSTEMFONT(14);
    [self addSubview:label];
    
       
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    checkBtn.tag = 2;
    [button setTitle:@"使用条款和隐私政策" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.11 green:0.50 blue:0.95 alpha:1.00] forState:UIControlStateNormal];
    button.titleLabel.font = SYSTEMFONT(14);
    button.frame = Rect(120, 0, 130, self.frameHeight);
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
}
-(void)checkClick:(id)sender{
    self.isFlag = !self.isFlag;
    
    UIButton *button = (UIButton *)sender;
    
    button.selected = self.isFlag ? YES :  NO;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(agreementViewButtonClick:)]) {
        [self.delegate agreementViewButtonClick:self.isFlag];
    }
    
}
-(void)buttonClick:(id)sender{
    if (self.isFlag) {
        MBaseViewController *viewCtrl = (MBaseViewController *)[self firstViewController];
        
        [MGo2PageUtility go2MWebBrowser:viewCtrl title:@"使用条款和隐私政策" webUrl:@"http://www.qianxs.com/mrMoney/mobile/invite/member/license.html"];
     }
 
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
