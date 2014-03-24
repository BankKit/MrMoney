//
//  MCalendarCell.m
//  MrMoney
//
//  Created by xingyong on 14-2-13.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//


#import "MCalendarCell.h"
#import "MCalendarData.h"

@implementation MCalendarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setData:(MCalendarData *)data{
    _data = data;
    _leftView.hidden = NO;
    _rightView.hidden = YES;
    
    self.productNameLabel1.text = _data.mname;
    
    float height =  [MStringUtility getStringHight:_data.mname font:SYSTEMFONT(14) width:120.];
    self.productNameLabel1.frameHeight = height;
    
    self.amountLabel1.text      = formatValue([_data.minvestMoney floatValue]/100);
    NSString *bank_name         = strOrEmpty([KBANK_DICT objectForKey:[_data.mbankId lowercaseString]]);
    self.bankNameLabel1.text    = bank_name;
    NSString *logoName          = STRING_FORMAT(@"logo_%@",strOrEmpty([_data.mbankId lowercaseString]));
    self.logo_iv1.image         = [UIImage imageNamed:logoName];
    
    
    _bgImageView1.userInteractionEnabled = YES;
      UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [_bgImageView1 addGestureRecognizer:singleTap];
   
 
  
}
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
      UIImageView *imageView = (UIImageView *)[gestureRecognizer view];
    if (self.imageViewBlock) {
        self.imageViewBlock(imageView.tag);
    }
     
     
}


-(void)setData2:(MCalendarData *)data2{
    _data = data2;
    _leftView.hidden=NO;
    _rightView.hidden =NO;
 
    self.productNameLabel2.text = _data.mname;
    
    float height =  [MStringUtility getStringHight:_data.mname font:SYSTEMFONT(14) width:120.];
    self.productNameLabel2.frameHeight = height;
    
    self.amountLabel2.text      = formatValue([_data.minvestMoney floatValue]/100);
    
    NSString *bank_name         = strOrEmpty([KBANK_DICT objectForKey:[_data.mbankId lowercaseString]]);
    self.bankNameLabel2.text    = bank_name;
    NSString *logoName          = STRING_FORMAT(@"logo_%@",strOrEmpty([_data.mbankId lowercaseString]));
    self.logo_iv2.image         = [UIImage imageNamed:logoName];
    
    _bgImageView2.userInteractionEnabled = YES;
     UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [_bgImageView2 addGestureRecognizer:singleTap];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.bgImageView1.image = [[UIImage imageNamed:@"calendar_ daily"] stretchableImageWithLeftCapWidth:50 topCapHeight:50];
    self.bgImageView2.image = [[UIImage imageNamed:@"calendar_ daily"] stretchableImageWithLeftCapWidth:50 topCapHeight:50];
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
