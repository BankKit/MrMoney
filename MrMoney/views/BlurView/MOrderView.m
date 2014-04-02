//
//  MOrderView.m
//  MrMoney
//
//  Created by xingyong on 14-3-28.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MOrderView.h"
#import "rmb_convert.h"

@implementation MOrderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    return self;
}
-(void)setData:(MFinanceProductData *)data{
    
    _data = data;
     
    self.product_nameLabel.text        = strOrEmpty(_data.mproduct_name);

    CGFloat height                     = [MStringUtility getStringHight:_data.mproduct_name font:SYSTEMFONT(14) width:190.];
    NSLog(@"------height-------------------------%f \n\n",height);

    self.product_nameLabel.frameHeight = height;

    _topView.frameY                    = self.product_nameLabel.frameY + self.product_nameLabel.frameHeight + 2;

    self.bank_logo_iv.image            = bankLogoImage(_data.mbank_id);

    self.bank_logo_iv.frameWidth       = [bankLogoImage(_data.mbank_id) size].width/2;

    self.bankNameLabel.frameX          = self.bank_logo_iv.frameX +  self.bank_logo_iv.frameWidth  + 5;

    self.bankNameLabel.text            = bankName(_data.mbank_id);

    self.expect_earningsLabel.text     = STRING_FORMAT(@"%.1f%%",[_data.mreturn_rate floatValue]/100);

    self.invest_cycleLabel.text        = STRING_FORMAT(@"%@天",strOrEmpty(_data.minvest_cycle));
    
    
    
}
-(void)setAmount:(int)amount{
    _amount = amount;
    
    self.amountLabel.text =STRING_FORMAT(@"￥%@", formatValue(_amount/100));
    
    NSString *upper_money  = [NSString stringWithUTF8String:to_upper_rmb(_amount/100)];
    self.uppderLabel.text  = upper_money;
    
    float value = [MUtility expectEarning:self.data];
    
    NSString *earn =  [NSString stringWithFormat:@"%.2f",value *_amount/100];
    
    self.earningsLabel.text = earn;
    
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
