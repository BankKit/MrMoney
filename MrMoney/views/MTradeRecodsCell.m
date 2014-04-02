//
//  MTradeRecodsCell.m
//  MrMoney
//
//  Created by xingyong on 14-1-10.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MTradeRecodsCell.h"
#import "MTradeData.h"
#import "CALayer+MCategory.h"
 
@implementation MTradeRecodsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (NSDate *)formatterDateString:(NSString *)dateStr{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat       = @"yyyyMMddHHmmss";
    NSDate *date               = [formatter dateFromString:dateStr];
    
    return date;
}
-(void)setData:(MTradeData *)data{
    _data                    = data;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [formatter stringFromDate:[self formatterDateString:_data.mtran_time]];
    
    _investDateLabel.text = dateStr;
 
    if ([_data.mtran_amount containsString:@"-"]) {

        _investMoneyLabel.text = STRING_FORMAT(@"%@元",formatValue([_data.mtran_amount floatValue]));

        _investMoneyLabel.textColor = [UIColor colorWithRed:0.25 green:0.61 blue:0.18 alpha:1.00];

    }else if ([_data.mCrDr intValue] == 1) {
     
        _investMoneyLabel.text = STRING_FORMAT(@"-%@元",        formatValue([_data.mtran_amount floatValue]));
        
        _investMoneyLabel.textColor = [UIColor colorWithRed:0.25 green:0.61 blue:0.18 alpha:1.00];
    }else{

        _investMoneyLabel.text = STRING_FORMAT(@"+%@元",        formatValue([_data.mtran_amount floatValue]));
    }
  
    _investBalanceLabel.text = _data.mtransTypeDesc;
 
    if ([_data.mtrans_status intValue] == 0) {
        _investDescLabel.text = @"交易成功";
    }

 
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.bgView.layer borderWidth:0.5 borderColor:KVIEW_BORDER_COLOR cornerRadius:5.0];
    
}

 


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
