//
//  MFinanceProductsCell.m
//  MrMoney
//
//  Created by xingyong on 13-12-4.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MFinanceProductsCell.h"
#import "MFinanceProductData.h"
#import "MFundData.h"
 
#include <stdio.h>
#include <math.h>
@implementation MFinanceProductsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Initialization code
    }
    return self;
}

-(void)setFund:(MFundData *)fund{
    _fund = fund;
    
    NSString *bank_name            = bankName(_fund.mfund_id);
    
    NSString *bank_name_info       = STRING_FORMAT(@"%@ %@",bank_name,strOrEmpty(_fund.mproduct_name));
    
    self.bank_nameLabel.text       = bank_name_info;
    
    self.bank_logo_iv.image        = bankLogoImage(_fund.mfund_id);
    
    NSString *returnType = nil;
    float    multipleValue = 0.0;
 
    
    if ([self.sortType isEqualToString:@"week_return"]) {
        returnType = STRING_FORMAT(@"%.2f%%",[_fund.mweek_return floatValue]/100);
        _markLabel.text = @"最近一周回报率";
        multipleValue = ([_fund.mweek_return floatValue]/100)/0.35;
  
    }else if([self.sortType isEqualToString:@"year_return"]){
        returnType = STRING_FORMAT(@"%.2f%%",[_fund.myear_return floatValue]/100);
        _markLabel.text = @"最近一年回报率";
        multipleValue = ([_fund.myear_return floatValue]/100)/0.35;
        
    }else{
        returnType = STRING_FORMAT(@"%.2f%%",[_fund.mestablish_return floatValue]/100);
        _markLabel.text = @"成立以来回报率";
        multipleValue = ([_fund.mestablish_return floatValue]/100)/0.35;
        
    }
    self.earningsLabel.text        = returnType;
    
    self.dayLabel.text             =  _fund.mnet_value;
    
    self.expect_earningsLabel.text =  STRING_FORMAT(@"%.2f倍",multipleValue);
    
    self.dateLabel.text            = [MStringUtility formatterDateString:STRING_FORMAT(@"%@",_fund.mnet_date)];
    
 
    
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
    
    UIImage *image = bankLogoImage(_data.mbank_id);
    
    self.bank_logo_iv.image        = image;
    
    
    self.bank_logo_iv.frameWidth   = image.width/2;
    self.bank_logo_iv.frameHeight  = image.height/2;
    
    self.bank_nameLabel.frameX =self.bank_logo_iv.frameX + image.width/2 + 5;
    
    self.bank_nameLabel.text       = STRING_FORMAT(@"%@ %@",bank_name,strOrEmpty(_data.mproduct_name));;
    
    self.earningsLabel.text        = STRING_FORMAT(@"%.2f%%",[_data.mreturn_rate floatValue]/100);
    
    
    float expect_earnings = ([_data.mreturn_rate floatValue]/100)/0.35;
    
    self.expect_earningsLabel.text =  STRING_FORMAT(@"%.2f倍",expect_earnings);
    

    if ([_data.minvest_cycle intValue] == -1) {
        self.dayLabel.text             = @"灵活周期";
    }else {
        self.dayLabel.text             = [NSString stringWithFormat:@"%@天",strOrEmpty(_data.minvest_cycle)];
    }
    
    self.dateLabel.text            = [MStringUtility formatterDateString:STRING_FORMAT(@"%@",_data.mvalue_date)];
    
    
//    [self setNeedsLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
