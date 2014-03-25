//
//  MMoneyBabyViewController.m
//  MrMoney
//
//  Created by xingyong on 13-12-4.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MMoneyBabyViewController.h"
#import "MTradeRecordViewController.h"
#import "MInvestRecordViewController.h"
#import "UICountingLabel.h"
#import "MMoneyBabyData.h"
#import "UIColor+MCategory.h"
 
#import "MRechargeViewController.h"
#import "MCountView.h"
@interface MMoneyBabyViewController ()

@property(nonatomic,assign)float todayIncome;
@property(nonatomic,copy) NSString *canWithdrawMoney;
@property(nonatomic,assign)double total;
@end

@implementation MMoneyBabyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createNavBarTitle:@"我的钱宝宝"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _middleView.backgroundColor = [UIColor fromHexString:@"#e6e6e6"];
    
    self.scrollView.contentSize = CGSizeMake(320, _bottomView.frameHeight + _bottomView.frameY);
    
    __weak MMoneyBabyViewController *wself = self;
    [self initRightButtonItem:@"nav_payment_card" title:@"银行卡" completionHandler:^{
       
        [MGo2PageUtility go2MWalletViewController:wself pushType:MWalletType canWithdraw:nil];

    }];
    


    if (self.money) {
        [self initViewData:self.money];
    }else{
        
        queryAction = [[MQueryInvestAction alloc] init];
        queryAction.m_delegate = self;
        [queryAction requestAction];
        
        [self showHUD];

    }
    
}


-(void)setBalanceLabelValue{
  
    MCountView *countView = [[MCountView alloc] initWithFrame:CGRectMake(12, 57, 303, 40) balance:_total todayIncome:_todayIncome type:MMoneyBabyType];
    [self.topView addSubview:countView];
 
}
-(void)initViewData:(MMoneyBabyData *)money{
    float currentIncome   = [money.mcurrentIncomeMoney floatValue]/100;
    float currentInvest   = [money.mcurrentInvestMoney  floatValue]/100;
    float blance          = [money.mbalance   floatValue]/100;
    float officialBalance = [money.mofficialBalance   floatValue]/100;
    float loadMoney       = [money.mloadMoney floatValue]/100;
    _todayIncome          = [money.mtodayIncome floatValue]/100;
    _total   = currentIncome + currentInvest + blance + officialBalance + loadMoney;
    

    [self setBalanceLabelValue];
    
    self.canWithdrawMoney = money.mcanDrawMoney;
    _canDrawMoneyLabel.text = formatValue([money.mcanDrawMoney floatValue]/100);
 
    _todayIncomeLabel.text = formatValue([money.mtodayIncome floatValue]/100);
    _todayInvestLabel.text = formatValue([money.mcurrentInvestMoney floatValue]/100);
    _sumIncomeMoneyLabel.text = formatValue([money.msumIncomeMoney floatValue]/100);
    
    _rate7Label.text = STRING_FORMAT(@"%@%%",money.mReal7Int);
    _balanceTreasureLabel.text = formatValue([money.mcyclBal floatValue]/100);
    _unusedMoneyLabel.text = formatValue([money.mdrawMoney floatValue]/100);
    
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    _userCountLabel.format = @"%d";
    [_userCountLabel countFrom:0 to:[self.money.muserCount intValue]];
    _userCountLabel.formatBlock = ^NSString* (float value)
    {
        NSString* formatted = [formatter stringFromNumber:@((int)value)];
        return [NSString stringWithFormat:@"%@人",formatted];
    };

}

-(NSDictionary*)onRequestQueryInvestAction{
    
    return @{@"mId": userMid()};
}
-(void)onResponseQueryInvestSuccess:(MMoneyBabyData *)money{
    [self hideHUD];
    
    [self initViewData:money];
}

-(void)setLabelFormat:(UICountingLabel *)label value:(float)value{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
     formatter.maximumFractionDigits = 2;
    label.format = @"%.2f%";
    [label countFrom:0.00 to:value];
    label.formatBlock = ^NSString* (float value)
    { 
        NSString* formatted = [formatter stringFromNumber:@((float)value)];
        return [NSString stringWithFormat:@"%@",formatted];
    };
    
}
-(void)onResponseQueryInvestFail{
    [self hideHUD];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
 
    queryAction.m_delegate = nil;
}

- (IBAction)onRechargeAction:(id)sender{
     MRechargeViewController *record = [[MRechargeViewController alloc] initWithNibName:@"MRechargeViewController" bundle:nil];
    
     [self.navigationController pushViewController:record animated:YES];
    
}
- (IBAction)investRecordAction:(id)sender{
    if ([sender tag] == 1) {
        MTradeRecordViewController *trade = [[MTradeRecordViewController alloc] init];
        [self.navigationController pushViewController:trade animated:YES];
    }
    else{
        MInvestRecordViewController *invest = [[MInvestRecordViewController alloc] init];
        [self.navigationController pushViewController:invest animated:YES];
    }

    
}
// 提现
- (IBAction)onWithdrawAction:(id)sender {
  
    [MGo2PageUtility go2MWalletViewController:self pushType:MMoneyBabyType canWithdraw:self.canWithdrawMoney];

}
- (IBAction)onSignAlipayAction:(id)sender{
    signAlipayAction = [[MSignAlipayAction alloc] init];
    signAlipayAction.m_delegate = self;
    [signAlipayAction requestAction];
    
}
-(NSDictionary*)onRequestSignAlipayAction{
    return @{@"mId": userMid()};
}
-(void)onResponseSignAlipayActionSuccess{
    [MActionUtility showAlert:@"签约成功"];
}
-(void)onResponseSignAlipayActionFail{
    [MActionUtility showAlert:@"签约失败"];    
}
@end


