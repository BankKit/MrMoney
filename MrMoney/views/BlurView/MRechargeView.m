//
//  MRechargeView.m
//  MrMoney
//
//  Created by xingyong on 14-3-28.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MRechargeView.h"
#import "rmb_convert.h"
@implementation MRechargeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setAmount:(int)amount{
    _amount = amount;
    
    self.amountLabel.text =STRING_FORMAT(@"￥%@", formatValue(_amount/100));
    
    NSString *upper_money  = [NSString stringWithUTF8String:to_upper_rmb(_amount/100)];
    self.uppderLabel.text  = upper_money;
     
}
-(void)setPayStyle:(NSString *)payStyle{
    
    payStyle = [payStyle lowercaseString];
    
    if([payStyle isEqualToString:@"comm"]){
        payStyle = @"bocom";
    }else if ([payStyle isEqualToString:@"bccb"]){
        payStyle = @"bob";
    }
    
    self.payStyleLabel.text = bankName(payStyle);
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    [_mainView.layer borderWidth:1.0 borderColor:KCLEAR_COLOR cornerRadius:6.];
    [_cancelBtn setBackgroundImage:KDEFAULT_GRAY_BTN forState:UIControlStateNormal];
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
