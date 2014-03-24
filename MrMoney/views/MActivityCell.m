//
//  MActivityCell.m
//  MrMoney
//
//  Created by xingyong on 14-2-27.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MActivityCell.h"
#import "MActivityData.h"
@implementation MActivityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setData:(MActivityData *)data{
    _data = data;
//    self.dateLabel.text = _data.mlastPostTime;
      self.titleLabel.text =_data.mactName;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([_data.mlastPostTime doubleValue] / 1000)];
    self.dateLabel.text =  [self stringFromDate:date];

    
    self.contentLabel.text = STRING_FORMAT(@"%@:%@",_data.mrealName,_data.mcontent);
//   KAVATAR_PATH(mId,iconPath)
    [self.thumb setImageWithURL:KAVATAR_PATH(_data.mownerId, _data.miconPath)];
//    MR00075122
}
- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MM/dd HH:MM"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
