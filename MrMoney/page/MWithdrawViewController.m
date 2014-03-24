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
   
//    _moneyUpperLabel.text = [NSString stringWithUTF8String:to_upper_rmb([self.canWithdrawMoney floatValue]/100)];
  
    
}
 
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _balanceField) {
        _moneyUpperLabel.text = [NSString stringWithUTF8String:to_upper_rmb([textField.text floatValue])];
        
    }
    
    
}
-(IBAction)onWithdrawAction:(id)sender{
    NSString *password = MSMD5(_passwordField.text);
    if ([self.canWithdrawMoney floatValue]/100 < 1) {
        [MActionUtility showAlert:@"没有可提现金额"];
        return;
    }
    if ([_balanceField.text intValue] < 0) {
        [MActionUtility showAlert:@"提现金额必须大于零"];
        return;
    }else if([_balanceField.text intValue] > [self.data.mcurrency intValue]/100){
        
        [MActionUtility showAlert:@"提现金额大于可提现金额"];
        return;
    }else if (![password isEqualToString:user_defaults_get_string(@"KPASSWORD")]){
        [MActionUtility showAlert:@"账户密码错误"];
        return;
    }
//
    
    withdrawAction = [[MWithdrawAction alloc] init];
    withdrawAction.m_delegate = self;
    [withdrawAction requestAction];
    [self showHUD];

}
-(NSDictionary*)onRequestWithdrawAction{
    MutableOrderedDictionary *dict = [MutableOrderedDictionary dictionaryWithCapacity:0];
    [dict setSafeObject:userMid() forKey:@"mId"];
    [dict setSafeObject:[NSNumber numberWithInt:[_balanceField.text intValue]*100] forKey:@"applyAmount"];
    [dict setSafeObject:self.data.maid forKey:@"aid"];
    [dict setSafeObject:_bankAddressLabel.text forKey:@"cardAddress"];

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
