//
//  MOrderView.h
//  MrMoney
//
//  Created by xingyong on 14-3-28.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFinanceProductData.h"
@interface MOrderView : UIView

@property(nonatomic,weak)IBOutlet UIView *mainView;
@property(nonatomic,weak)IBOutlet UIView *topView;
@property(nonatomic,weak)IBOutlet UIView *bottomView;

@property(nonatomic,weak)IBOutlet UIButton *cancelBtn;
@property (nonatomic,strong)MFinanceProductData *data;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *product_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *expect_earningsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bank_logo_iv;
@property (weak, nonatomic) IBOutlet UILabel *invest_cycleLabel;

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *uppderLabel;
@property (weak, nonatomic) IBOutlet UILabel *earningsLabel;
@property (weak, nonatomic) IBOutlet UILabel *payStyleLabel;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property(nonatomic,assign)int amount;
@property(nonatomic,copy) NSString *payStyle;



@end
