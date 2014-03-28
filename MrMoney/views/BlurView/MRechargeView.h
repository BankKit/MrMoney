//
//  MRechargeView.h
//  MrMoney
//
//  Created by xingyong on 14-3-28.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRechargeView : UIView

@property(nonatomic,weak)IBOutlet UIView *mainView;
@property(nonatomic,weak)IBOutlet UIView *topView;
@property(nonatomic,weak)IBOutlet UIView *bottomView;




@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *uppderLabel;
 
@property (weak, nonatomic) IBOutlet UILabel *payStyleLabel;
@property(nonatomic,weak)IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property(nonatomic,assign)int amount;
@property(nonatomic,copy) NSString *payStyle;

@end
