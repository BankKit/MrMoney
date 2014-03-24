//
//  MSetupCell.m
//  MrMoney
//
//  Created by xingyong on 13-12-3.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MAccountCell.h"
#import "CALayer+MCategory.h"
@implementation MAccountCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
        
        self.textLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.highlightedTextColor =[UIColor blackColor];
        
        self.detailTextLabel.textColor =[UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:0.6];
        self.detailTextLabel.highlightedTextColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0];
        
        _thumb = [[UIImageView alloc] initWithFrame:CGRectMake(230, 5, 60, 60)];
        [_thumb.layer borderWidth:2.0 borderColor:KCLEAR_COLOR cornerRadius:4.0];
        [self addSubview:_thumb];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 2, 185, 40)];
        _contentLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        _contentLabel.textAlignment = NSTextAlignmentRight;
        _contentLabel.textColor = [UIColor lightGrayColor];
        _contentLabel.highlightedTextColor =[UIColor lightGrayColor];
        _contentLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentLabel];
  
 
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
