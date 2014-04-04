//
//  MRecordCell.m
//  MrMoney
//
//  Created by xingyong on 14-1-23.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MRecordCell.h"
#import "MInvestRecordData.h"
#import "NSDate+DateTools.h"
@implementation MRecordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}



-(void)setData:(MInvestRecordData *)data{
    _data                    = data;
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
//    NSString *dateStr = [formatter stringFromDate:[self formatterDateString:_data.mtran_time]];
// 
    NSDate *tran_date = [MUtility dateFormatter:_data.mtran_time formatter:kDefaultTimeStampFull];
    NSString *tran_time =  [tran_date formattedDateWithFormat:@"yyyy-MM-dd HH:mm"];
    
    _investDateLabel.text = tran_time;
    
  
    _investMoneyLabel.text = STRING_FORMAT(@"+%@元",_data.mtran_amount);
    if ([_data.mTrxType intValue] == 2) {
        _investMoneyLabel.textColor = [UIColor orangeColor];
    }else if([_data.mTrxType intValue] == 5){
        
        _investMoneyLabel.textColor = [UIColor blackColor];
        _investMoneyLabel.text = STRING_FORMAT(@"%@元",_data.mtran_amount);

    }
 
    _investStatusLabel.text = _data.mtransTypeDesc;
    
    _investNumberLabel.text = _data.mBsnsStsDesc;
  
    
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
