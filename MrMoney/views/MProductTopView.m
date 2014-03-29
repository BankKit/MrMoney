//
//  MProductTopView.m
//  MrMoney
//
//  Created by xingyong on 14-3-29.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MProductTopView.h"
#import "MFinanceProductData.h"
@implementation MProductTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setData:(MFinanceProductData *)data{
    _data = data;
    
    NSString *bank_name = nil;
    
    NSArray *keyArray =    [KTREASURE_DICT allKeys];
    
    if ([keyArray containsObject:[_data.mbank_id lowercaseString]]) {
        bank_name = [KTREASURE_DICT objectForKey:[_data.mbank_id lowercaseString]];
    }else{
        bank_name            = bankName(_data.mbank_id);
    }
    
    
    self.product_nameLabel.text        = strOrEmpty(_data.mproduct_name);
    
    CGFloat height = [MStringUtility getStringHight:_data.mproduct_name font:SYSTEMFONT(16) width:260.];
    
    self.product_nameLabel.frameHeight = height + 5.;
    
    _mainView.frameY                   = self.product_nameLabel.frameY + height - 5;
    
    self.bankNameLabel.text            = bank_name;
    
    self.bank_logo_iv.image            = bankLogoImage(_data.mbank_id);
    
    self.bank_logo_iv.frameWidth       = bankLogoImage(_data.mbank_id).width/2;
    
    self.bankNameLabel.frameX          = self.bank_logo_iv.frameX +  self.bank_logo_iv.frameWidth  + 5;
    
    self.earningsLabel.text        = STRING_FORMAT(@"%.1f%%",[_data.mreturn_rate floatValue]/100);
    
    if ([_data.minvest_cycle intValue] == -1) {
        self.dayLabel.text             = @"灵活周期";
    }else{
        self.dayLabel.text        = STRING_FORMAT(@"%@天",strOrEmpty(data.minvest_cycle));
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
