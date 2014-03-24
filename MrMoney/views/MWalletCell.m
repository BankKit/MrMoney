//
//  MWalletCell.m
//  MrMoney
//
//  Created by xingyong on 13-12-5.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MWalletCell.h"
#import "MAccountsData.h"
 
@implementation MWalletCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setData:(MAccountsData *)data{
    _data = data;
    
    self.bankNoLabel.text   = formatCardNo(_data.mbankCardNo);
 
    
    _balanceLabel.text =  formatValue([_data.mcurrency floatValue]/100);
    
    if ([_data.mdollar floatValue]/100 > 0.00) {
        _dollarLabel.hidden = NO;
        _dollarTitleLabel.hidden = NO;
        _dollarLabel.text =  formatValue([_data.mdollar floatValue]/100);

    }
    if ([_data.mdollar floatValue]/100>0.0) {
        self.contentView.frameHeight = 68;
    }else{
        self.contentView.frameHeight = 60;
    }
    
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.roundView.delegate = self;
    self.roundView.roundImage = [UIImage imageNamed:@"home_cell_loading"];
    self.roundView.rotationDuration = 2.0;
    self.roundView.isPlay = NO;
}
-(void)playStatuUpdate:(BOOL)playState
{
    NSLog(@"%@...", playState ? @"播放": @"暂停了");
}

-(IBAction)buttonClick:(id)sender{
  
    MCustomButton *btn = (MCustomButton *)sender;
  
    if (self.btnHandler) {
        self.btnHandler(btn.indexPath,_roundView);
    }
 
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
