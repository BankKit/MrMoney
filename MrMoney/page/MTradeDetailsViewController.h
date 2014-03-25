//
//  MTradeDetailsViewController.h
//  MrMoney
//
//  Created by xingyong on 14-1-16.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
#import "MTradeData.h"
#import "MInvestRecordData.h"
@interface MTradeDetailsViewController : MBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property(nonatomic,strong) MTradeData *data;
@property(nonatomic,strong) MInvestRecordData *investData;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
 
@property (weak, nonatomic) IBOutlet UILabel *titleStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *monadButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;



@property(nonatomic,assign)int typeValue;

/**
 *  查看回执单
 *
 */
-(IBAction)onSeeMonadAction:(id)sender;
@end
