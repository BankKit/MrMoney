//
//  MFinanceProductsCell.h
//  MrMoney
//
//  Created by xingyong on 13-12-4.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MFinanceProductData;
@class MFundData;
@interface MFinanceProductsCell : UITableViewCell

@property(nonatomic,strong)MFinanceProductData *data;
@property(nonatomic,strong)MFundData *fund;
@property(nonatomic,strong)NSString *sortType;


@property (nonatomic,weak)IBOutlet UILabel     * dayLabel;
@property (nonatomic,weak)IBOutlet UILabel     * dateLabel;
@property (nonatomic,weak)IBOutlet UILabel     * earningsLabel;
@property (nonatomic,weak)IBOutlet UILabel     * expect_earningsLabel;
@property (nonatomic,weak)IBOutlet UILabel     * bank_nameLabel;
@property (nonatomic,weak)IBOutlet UIImageView * bank_logo_iv;

@property (nonatomic,weak)IBOutlet UILabel *markLabel;
 
@end
