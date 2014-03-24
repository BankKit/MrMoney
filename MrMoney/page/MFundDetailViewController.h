//
//  MFundDetailViewController.h
//  MrMoney
//
//  Created by xingyong on 14-2-22.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
@class MFundData;
@interface MFundDetailViewController : MBaseViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet MBorderView *topView;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;


@property (nonatomic,weak)IBOutlet UILabel     * netValueLabel;
@property (nonatomic,weak)IBOutlet UILabel     * dateLabel;

@property (nonatomic,weak)IBOutlet UILabel     * bank_nameLabel;
@property (nonatomic,weak)IBOutlet UILabel     * fund_nameLabel;
@property (nonatomic,weak)IBOutlet UIImageView * bank_logo_iv;

@property (nonatomic,weak)IBOutlet UILabel     * fundCodeLabel;
@property (nonatomic,weak)IBOutlet UILabel     * fundTypeLabel;
@property (nonatomic,weak)IBOutlet UILabel     * totalNetValueLabel;
@property (nonatomic,weak)IBOutlet UILabel     * establishDateLabel;


@property (nonatomic,weak)IBOutlet UILabel     * weekReturnLabel;
@property (nonatomic,weak)IBOutlet UILabel     * yearReturnLabel;
@property (nonatomic,weak)IBOutlet UILabel     * establishReturnLabel;



@property(nonatomic,strong)MFundData *fund;

@end
