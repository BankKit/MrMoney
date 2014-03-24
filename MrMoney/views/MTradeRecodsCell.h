//
//  MTradeRecodsCell.h
//  MrMoney
//
//  Created by xingyong on 14-1-10.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTradeData;
@interface MTradeRecodsCell : UITableViewCell

@property(nonatomic,strong)MTradeData *data;
 

@property (nonatomic,weak) IBOutlet UILabel  *investBalanceLabel; 
@property (nonatomic,weak) IBOutlet UILabel  *investMoneyLabel;//投资金额
@property (nonatomic,weak) IBOutlet UILabel  *investDateLabel;//投资时间
@property (nonatomic,weak) IBOutlet UILabel  *investDescLabel;

@property (nonatomic,weak) IBOutlet UIView   *bgView;
@end
