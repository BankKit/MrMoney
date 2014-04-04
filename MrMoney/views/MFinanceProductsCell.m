//
//  MFinanceProductsCell.m
//  MrMoney
//
//  Created by xingyong on 13-12-4.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MFinanceProductsCell.h"
#import "MFinanceProductData.h"
#import "MInternetData.h"
#import "MFundData.h"
#import "MLabel.h"
//#include <stdio.h>
//#include <math.h>
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
    
    _earningsLabel.text = returnType;
    [_earningsLabel setFontColor:[UIColor lightGrayColor] string:@"%"];
    [_earningsLabel setFont:SYSTEMFONT(12) string:@"%"];
    
   
    self.dayLabel.text             =  _fund.mnet_value;
    
    self.expect_earningsLabel.text =  STRING_FORMAT(@"%.2f倍",multipleValue);
    
    
    self.dateLabel.text            = [MUtility dateString:_fund.mnet_date];
 
      [self setNeedsLayout];
}

- (void)setData:(MFinanceProductData *)data{
    _data = data;
    
    UIImage *image = bankLogoImage(_data.mbank_id);
    
    self.bank_logo_iv.image        = image;
    
    self.bank_logo_iv.frameWidth   = image.width/2;
    self.bank_logo_iv.frameHeight  = image.height/2;
    
    self.bank_nameLabel.frameX =self.bank_logo_iv.frameX + image.width/2 + 5;

    self.bank_nameLabel.text       = STRING_FORMAT(@"%@ %@",bankName(_data.mbank_id),strOrEmpty(_data.mproduct_name));
    
    self.earningsLabel.text        = STRING_FORMAT(@"%.2f%%",[_data.mreturn_rate floatValue]/100);
    
    [_earningsLabel setFontColor:[UIColor lightGrayColor] string:@"%"];
    [_earningsLabel setFont:SYSTEMFONT(12) string:@"%"];
    
    float expect_earnings = ([_data.mreturn_rate floatValue]/100)/0.35;
    
    self.expect_earningsLabel.text =  STRING_FORMAT(@"%.2f倍",expect_earnings);
     self.dayLabel.text             = [NSString stringWithFormat:@"%@天",strOrEmpty(_data.minvest_cycle)];
    [_dayLabel setFontColor:[UIColor lightGrayColor] string:@"天"];
    [_dayLabel setFont:SYSTEMFONT(12) string:@"天"];
    
    self.dateLabel.text            = [MUtility dateString:_data.mvalue_date];
  
//     [self setNeedsLayout];
}

-(void)setInternet:(MInternetData *)internet{
    _internet = internet;
 
    
    UIImage *image = bankLogoImage(_internet.msite_id);
    
    self.bank_logo_iv.image        = image;
    
    
    self.bank_logo_iv.frameWidth   = image.width/2;
    self.bank_logo_iv.frameHeight  = image.height/2;
    
    self.bank_nameLabel.frameX =self.bank_logo_iv.frameX + image.width/2 + 5;
    
    self.bank_nameLabel.text       = STRING_FORMAT(@"%@ %@",bankName(_internet.msite_id),strOrEmpty(_internet.mproduct_name));;
 
    self.earningsLabel.text        = STRING_FORMAT(@"%@%%",_internet.mweek_return_rate);
    
    [_earningsLabel setFontColor:[UIColor lightGrayColor] string:@"%"];
    [_earningsLabel setFont:SYSTEMFONT(12) string:@"%"];
    
    self.markLabel.text = @"七日年化收益";
    
    float expect_earnings = ([_internet.mweek_return_rate floatValue])/0.35;
    
    self.expect_earningsLabel.text =  STRING_FORMAT(@"%.2f倍",expect_earnings);
    
    //万分收益率
    
    
    if ([self.sortType isEqualToString:@"week_return_rate"]) {
        
        _dayLabel.text             = STRING_FORMAT(@"%@",internet.mincome_10th);
 
        _dateLabel.text            = @"万份收益";
 
        
    }else if([self.sortType isEqualToString:@"lowest_amount"]){

        _dayLabel.text             = STRING_FORMAT(@"%.2f", [internet.mlowest_amount floatValue]);
        
        _dateLabel.text            = @"投资起售金额";
 
        
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
