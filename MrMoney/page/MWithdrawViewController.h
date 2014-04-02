//
//  MWithdrawViewController.h
//  MrMoney
//
//  Created by xingyong on 14-2-28.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
#import "MWithdrawAction.h"
#import "MObtainFeeAction.h"
@class MAccountsData;

@interface MWithdrawViewController : MBaseViewController<UIAlertViewDelegate,MWithdrawActionDelegate,MObtainActionDelegate>{
    MWithdrawAction *withdrawAction;
    MObtainFeeAction *obtainFeeAction;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property(nonatomic,strong) MAccountsData *data;

@property(nonatomic,strong) NSString *bankAddress;
@property(nonatomic,strong) NSString *subsidiaryAddress;
@property(copy,nonatomic)NSString *canWithdrawMoney;

@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNOLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankAddressLabel;

@property (weak, nonatomic) IBOutlet UILabel *canWithdrawLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyUpperLabel;
@property (weak, nonatomic) IBOutlet UITextField *balanceField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

-(IBAction)onWithdrawAction:(id)sender;

@end
