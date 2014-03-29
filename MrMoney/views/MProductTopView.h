//
//  MProductTopView.h
//  MrMoney
//
//  Created by xingyong on 14-3-29.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MProductTopView : MBorderView
@property (weak, nonatomic) IBOutlet UIImageView *bank_logo_iv;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *product_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *earningsLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@property (weak,nonatomic) IBOutlet  UIView *mainView;

@property (strong, nonatomic) MFinanceProductData *data;
@end
