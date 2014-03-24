//
//  MCommentCell.m
//  MrMoney
//
//  Created by xingyong on 13-12-6.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MCommentCell.h"
//#import "NSDateHelper.h"
@implementation MCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setData:(MCommentData *)data{
    _data = data;
   
    self.contentLabel.text = _data.mcontent;
    
    self.nameLabel.text = _data.mloginName;
    
 
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([_data.mpostDate doubleValue] / 1000)];
    self.dateLabel.text =  [self stringFromDate:date];
 
    if (![strOrEmpty(_data.miconPath) isEqualToString:@""]) {
         
        [self.thumbnail setImageWithURL:KAVATAR_PATH(_data.mmid, _data.miconPath)];
    }
    else{
        self.thumbnail.image = [UIImage imageNamed:@"default_qbaobao"];
    }

    self.contentLabel.frameHeight = [[self class] heightForCommentCell:_data] - 40;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.thumbnail.layer borderWidth:1.0 borderColor:KCLEAR_COLOR cornerRadius:3.0];
}

- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:MM"];
     
    NSString *destDateString = [dateFormatter stringFromDate:date];
         
    return destDateString;
    
}
+(float)heightForCommentCell:(MCommentData *)data{
    float height = [MStringUtility getStringHight:data.mcontent font:SYSTEMFONT(14) width:200.f];
    
    return fmaxf(65.0f, height + 40);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
