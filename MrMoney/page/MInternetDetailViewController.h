//
//  MInternetDetailViewController.h
//  MrMoney
//
//  Created by xingyong on 14-3-27.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
@class MInternetData;
@interface MInternetDetailViewController : MBaseViewController
@property (nonatomic,strong) MInternetData *data;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *product_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *expect_earningsLabel;
//@property (weak, nonatomic) IBOutlet UILabel *currency_typeLabel;
//@property (weak, nonatomic) IBOutlet UILabel *product_typeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bank_logo_iv;
@property (weak, nonatomic) IBOutlet UILabel *invest_cycleLabel;


@end
