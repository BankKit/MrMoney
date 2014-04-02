//
//  MWithdrawViewController.m
//  MrMoney
//
//  Created by xingyong on 14-2-28.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MWithdrawViewController.h"
#import "MAccountsData.h"
#import "rmb_convert.h"
@interface MWithdrawViewController ()
@property(nonatomic,assign) float feeValue;
@end

@implementation MWithdrawViewController

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
    [self createNavBarTitle:@"提现"];

    [self initViewUI];
}
-(void)initViewUI{
    [_topView.layer borderWidth:0.6 borderColor:KVIEW_BORDER_COLOR cornerRadius:6.];
    
    [_bottomView.layer borderWidth:0.6 borderColor:KVIEW_BORDER_COLOR cornerRadius:6.];
    
    _topView.frameX     = 10.;
    _topView.frameY     = 10.;
    _bottomView.frameX  = 10.;

    [_bottomView lockDistance:10. toView:_topView measureGuideline:OUOViewDistanceMeasureGuidelineTopToButtom];
    
    [self.scrollView addSubview:_bottomView];
    [self.scrollView addSubview:_topView];
    
    [self.scrollView setContentSize:CGSizeMake(320,self.bottomView.frameBottom + 10.)];
    
    _bankAddressLabel.text = STRING_FORMAT(@"%@ %@", _bankAddress,_subsidiaryAddress);
    _bankNOLabel.text = formatCardNo(self.data.mbankCardNo);
    
    NSString *bankId = self.data.mbankId;
    if ([bankId isEqualToString:@"PABACCT"]) {
        bankId = @"PAB";
    }
    _bankNameLabel.text = bankName(bankId);
    _bankUserNameLabel.text = self.data.mname;
    
    if ([self.canWithdrawMoney floatValue]/100 > 1) {
        
        float moneyValue =  [self.canWithdrawMoney floatValue]/100;
        
        _canWithdrawLabel.text = STRING_FORMAT(@"%.2f元", moneyValue);
    }
 
    
}
 
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _balanceField) {
        _moneyUpperLabel.text = [NSString stringWithUTF8String:to_upper_rmb([textField.text floatValue])];
        
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        withdrawAction = [[MWithdrawAction alloc] init];
        withdrawAction.m_delegate = self;
        [withdrawAction requestAction];
        [self showHUD];
    }
}
#pragma mark -------------  查询手续费 -----------------

-(NSDictionary*)onRequestObtainAction{
    MutableOrderedDictionary *dict = [MutableOrderedDictionary dictionaryWithCapacity:3];
    [dict setSafeObject:userMid() forKey:@"mid"];
    [dict setSafeObject:[NSNumber numberWithInt:[_balanceField.text intValue]] forKey:@"withDrawMoney"];
    [dict setSafeObject:@"03" forKey:@"tranChannel"];

    return dict;
    
}
-(void)onResponseObtainActionSuccess:(NSString *)fee{
    [self hideHUD];
    self.feeValue = [fee floatValue];
    NSString *msg = STRING_FORMAT(@"当前提现的手续费位%.2f元，将在返回给你的资金中直接扣取，确认现在提现？",[fee floatValue]);
    [MActionUtility showAlert:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    
}
-(void)onResponseObtainActionFail{
    [self hideHUD];
}
-(IBAction)onWithdrawAction:(id)sender{
    NSLog(@"----------------mcurrency---------------%f \n\n", [self.canWithdrawMoney floatValue]);
    NSLog(@"----------------_balanceField.text---------------%f \n\n", [_balanceField.text floatValue]);
 
    
    if ([_passwordField.text length] == 0) {
        [MActionUtility showAlert:@"密码不能为空"];
        return;
    }
    
    NSString *password = MSMD5(_passwordField.text);
    
    if ([self.canWithdrawMoney floatValue]/100 < 1) {
        [MActionUtility showAlert:@"没有可提现金额"];
        return;
    }
    if ([_balanceField.text floatValue] < 0.) {
        [MActionUtility showAlert:@"提现金额必须大于零"];
        return;
    }else if([_balanceField.text floatValue] > [self.canWithdrawMoney floatValue]/100){
        
        [MActionUtility showAlert:@"提现金额金额过大"];
        return;
    }else if (![password isEqualToString:user_defaults_get_string(@"KPASSWORD")]){
        [MActionUtility showAlert:@"账户密码错误"];
        return;
    }

    
    //查询手续费
    obtainFeeAction =  [[MObtainFeeAction alloc] init];
    obtainFeeAction.m_delegate = self;
    [obtainFeeAction requestAction];
    [self showHUD];
   

}
#pragma mark -------------  申请提现代理 -----------------

-(NSDictionary*)onRequestWithdrawAction{
    MutableOrderedDictionary *dict = [MutableOrderedDictionary dictionaryWithCapacity:0];

    [dict setSafeObject:userMid() forKey:@"mId"];
    [dict setSafeObject:[NSNumber numberWithInt:[_balanceField.text intValue]*100] forKey:@"applyAmount"];
    [dict setSafeObject:self.data.maid forKey:@"aid"];
    [dict setSafeObject:_bankAddressLabel.text forKey:@"cardAddress"];
    [dict setSafeObject:[NSNumber numberWithFloat:self.feeValue] forKey:@"fee"];
    [dict setSafeObject:@"03" forKey:@"tranChannel"];

    return dict;
}
-(void)onResponseWithdrawSuccess{
    
 
    [self hideHUDWithCompletionMessage:@"提现成功" finishedHandler:^{
         [[NSNotificationCenter defaultCenter] postNotificationName:KNOTITICATION_BLANCE object:nil];
    }];
    
}
-(void)onResponseWithdrawFail{
    [self hideHUDWithCompletionMessage:@"提现失败"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
