//
//  MRecordCell.h
//  MrMoney
//
//  Created by xingyong on 14-1-23.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MInvestRecordData;
@interface MRecordCell : UITableViewCell

@property(nonatomic,strong)MInvestRecordData *data;

@property (nonatomic,weak) IBOutlet UILabel  *investStatusLabel;//投资状态
@property (nonatomic,weak) IBOutlet UILabel  *investMoneyLabel;//投资金额
@property (nonatomic,weak) IBOutlet UILabel  *investDateLabel;//投资时间
@property (nonatomic,weak) IBOutlet UILabel  *investNumberLabel;//投资时间

@property (nonatomic,weak) IBOutlet UIView   *bgView;

@end
